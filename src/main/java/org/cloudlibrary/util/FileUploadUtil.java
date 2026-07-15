package org.cloudlibrary.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * 文件上传安全验证和处理工具类
 */
public class FileUploadUtil {

    /** 允许的图片文件扩展名（小写） */
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"
    ));

    /** 允许的 MIME 类型 */
    private static final Set<String> ALLOWED_MIME_TYPES = new HashSet<>(Arrays.asList(
            "image/jpeg", "image/png", "image/gif", "image/webp", "image/bmp"
    ));

    /** 最大文件大小：5MB */
    public static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    /**
     * 验证文件扩展名是否合法
     *
     * @param filename 原始文件名
     * @return true 如果扩展名在白名单中
     */
    public static boolean isAllowedExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return false;
        }
        String lowerFilename = filename.toLowerCase();
        int lastDot = lowerFilename.lastIndexOf('.');
        if (lastDot < 0 || lastDot == lowerFilename.length() - 1) {
            return false;
        }
        String extension = lowerFilename.substring(lastDot);
        return ALLOWED_EXTENSIONS.contains(extension);
    }

    /**
     * 验证 MIME 类型是否合法
     *
     * @param contentType 文件的 Content-Type
     * @return true 如果 MIME 类型在白名单中
     */
    public static boolean isAllowedMimeType(String contentType) {
        if (contentType == null || contentType.isEmpty()) {
            return false;
        }
        // Content-Type 可能包含 charset 等参数，只取主类型
        String mimeType = contentType.split(";")[0].trim().toLowerCase();
        return ALLOWED_MIME_TYPES.contains(mimeType);
    }

    /**
     * 综合验证文件是否安全可上传
     *
     * @param filename    原始文件名
     * @param contentType 文件的 Content-Type
     * @param fileSize    文件大小（字节）
     * @return null 如果验证通过；否则返回错误信息
     */
    public static String validate(String filename, String contentType, long fileSize) {
        if (filename == null || filename.isEmpty()) {
            return "未选择文件";
        }
        if (!isAllowedExtension(filename)) {
            return "不支持的文件类型，仅允许: jpg, jpeg, png, gif, webp, bmp";
        }
        if (contentType != null && !contentType.isEmpty() && !isAllowedMimeType(contentType)) {
            return "文件MIME类型不合法: " + contentType;
        }
        if (fileSize > MAX_FILE_SIZE) {
            return "文件大小超过限制（最大5MB）";
        }
        if (fileSize == 0) {
            return "文件内容为空";
        }
        return null; // 验证通过
    }

    /**
     * 从文件名中提取扩展名（含点号，小写）
     *
     * @param filename 文件名
     * @return 扩展名（如 ".jpg"），无扩展名时返回空字符串
     */
    public static String getExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }
        int lastDot = filename.lastIndexOf('.');
        if (lastDot < 0 || lastDot == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDot).toLowerCase();
    }

    /**
     * 上传文件：验证 + 创建目录 + 保存 + 返回相对路径
     *
     * @param file      上传的文件
     * @param uploadDir 上传目标目录的绝对路径
     * @param pathPrefix 存入数据库的路径前缀（如 "/uploads/books/"）
     * @return 保存后的相对路径（如 "/uploads/books/xxx.jpg"）
     * @throws IOException 文件保存失败
     * @throws IllegalArgumentException 验证失败
     */
    public static String uploadFile(MultipartFile file, String uploadDir, String pathPrefix)
            throws IOException, IllegalArgumentException {
        // 验证文件
        String validationError = validate(
                file.getOriginalFilename(), file.getContentType(), file.getSize());
        if (validationError != null) {
            throw new IllegalArgumentException(validationError);
        }

        // 确保目录存在
        File dir = new File(uploadDir);
        if (!dir.exists() && !dir.mkdirs()) {
            throw new IOException("无法创建上传目录: " + uploadDir);
        }

        // 生成唯一文件名
        String extension = getExtension(file.getOriginalFilename());
        String newFilename = UUID.randomUUID().toString() + extension;

        // 保存文件
        File targetFile = new File(dir, newFilename);
        file.transferTo(targetFile);

        // 返回相对路径
        return pathPrefix + newFilename;
    }
}
