package org.cloudlibrary.service.impl;

import org.cloudlibrary.constant.StatusConstants;
import org.cloudlibrary.entity.User;
import org.cloudlibrary.mapper.UserMapper;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.service.UserService;
import org.cloudlibrary.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BorrowService borrowService;

    @Override
    public User login(String username, String password) {
        // 根据用户名查询用户（含密码）
        User user = userMapper.selectByUsername(username);
        if (user == null || !"user".equals(user.getRole()) || user.getStatus() != StatusConstants.ENABLED) {
            return null;
        }
        // 验证密码（支持BCrypt哈希和旧的明文密码）
        if (PasswordUtil.checkPassword(password, user.getPassword())) {
            // 如果是明文密码，自动迁移为BCrypt哈希
            if (!PasswordUtil.isBCryptHash(user.getPassword())) {
                User updateUser = new User();
                updateUser.setId(user.getId());
                updateUser.setPassword(PasswordUtil.hashPassword(password));
                userMapper.update(updateUser);
            }
            return user;
        }
        return null;
    }

    @Override
    public User getUserById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public User getUserByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    @Override
    public List<User> getUsersByPage(int offset, int size) {
        return userMapper.selectByPage(offset, size);
    }

    @Override
    public List<User> searchUsers(String keyword, int offset, int size) {
        return userMapper.searchUsers(keyword, offset, size);
    }

    @Override
    public int countSearchUsers(String keyword) {
        return userMapper.countSearchUsers(keyword);
    }

    @Override
    public int countTotalUser() {
        return userMapper.countTotalUser();
    }

    @Override
    public List<User> getActiveUsers(int limit) {
        return userMapper.selectActiveUsers(limit);
    }

    @Override
    public int addUser(User user) {
        // 设置默认值
        user.setRole("user");
        user.setStatus(StatusConstants.ENABLED);
        // 密码BCrypt哈希后存储
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        }
        return userMapper.insert(user);
    }

    @Override
    public int updateUser(User user) {
        // 如果密码非空，进行BCrypt哈希
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        }
        return userMapper.update(user);
    }

    @Override
    public int deleteUser(Integer id) {
        return userMapper.deleteById(id);
    }

    // ========== 业务方法 ==========

    @Override
    public void updateProfile(Integer userId, User user, String oldPassword, String confirmPassword) {
        // 获取数据库中的用户信息（含密码）
        User dbUser = userMapper.selectByUsername(user.getUsername());
        if (dbUser == null || !dbUser.getId().equals(userId)) {
            throw new IllegalArgumentException("用户信息验证失败");
        }

        // 如果提供了旧密码，则修改密码
        if (oldPassword != null && !oldPassword.isEmpty()) {
            if (!PasswordUtil.checkPassword(oldPassword, dbUser.getPassword())) {
                throw new IllegalArgumentException("旧密码输入错误");
            }
            if (user.getPassword() == null || !user.getPassword().equals(confirmPassword)) {
                throw new IllegalArgumentException("新密码与确认密码不一致");
            }
            // 新密码会在update中哈希
        } else {
            // 不修改密码
            user.setPassword(null);
        }

        // 保留不可修改的字段
        user.setId(userId);
        user.setStatus(dbUser.getStatus());
        user.setRole(dbUser.getRole());

        updateUser(user);
    }

    @Override
    public void deleteUserIfNoBorrows(Integer id) {
        int borrowCount = borrowService.countByUserId(id);
        if (borrowCount > 0) {
            throw new IllegalStateException("该用户存在借阅记录，无法删除");
        }
        userMapper.deleteById(id);
    }
}