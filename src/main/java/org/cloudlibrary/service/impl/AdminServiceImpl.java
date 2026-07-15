package org.cloudlibrary.service.impl;

import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.mapper.AdminMapper;
import org.cloudlibrary.service.AdminService;
import org.cloudlibrary.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public Admin login(String username, String password) {
        // 根据用户名查询管理员（含密码）
        Admin admin = adminMapper.selectByUsername(username);
        if (admin == null || !"admin".equals(admin.getRole())) {
            return null;
        }
        // 验证密码（支持BCrypt哈希和旧的明文密码）
        if (PasswordUtil.checkPassword(password, admin.getPassword())) {
            // 如果是明文密码，自动迁移为BCrypt哈希
            if (!PasswordUtil.isBCryptHash(admin.getPassword())) {
                Admin updateAdmin = new Admin();
                updateAdmin.setId(admin.getId());
                updateAdmin.setPassword(PasswordUtil.hashPassword(password));
                adminMapper.update(updateAdmin);
            }
            return admin;
        }
        return null;
    }

    @Override
    public Admin getAdminById(Integer id) {
        return adminMapper.selectById(id);
    }

    @Override
    public int updateAdmin(Admin admin) {
        // 如果密码非空，进行BCrypt哈希
        if (admin.getPassword() != null && !admin.getPassword().isEmpty()) {
            admin.setPassword(PasswordUtil.hashPassword(admin.getPassword()));
        }
        return adminMapper.update(admin);
    }

    @Override
    public void updateProfile(Integer adminId, Admin admin) {
        // 获取数据库中的管理员信息
        Admin dbAdmin = adminMapper.selectById(adminId);
        if (dbAdmin == null) {
            throw new IllegalArgumentException("管理员信息验证失败");
        }
        // 保留不可修改的字段
        admin.setId(adminId);
        admin.setPassword(null); // 不修改密码
        admin.setPhone(dbAdmin.getPhone()); // 保留原电话
        adminMapper.update(admin);
    }
}