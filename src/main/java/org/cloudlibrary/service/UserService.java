package org.cloudlibrary.service;

import org.cloudlibrary.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login(String username, String password);
    User getUserById(Integer id);
    User getUserByUsername(String username);
    List<User> getUsersByPage(int offset, int size);
    List<User> searchUsers(String keyword, int offset, int size);
    int countTotalUser();
    int countSearchUsers(String keyword);
    List<User> getActiveUsers(int limit); // 活跃用户排行榜
    int addUser(User user);
    int updateUser(User user);
    int deleteUser(Integer id);

    // 业务方法
    void updateProfile(Integer userId, User user, String oldPassword, String confirmPassword);
    void deleteUserIfNoBorrows(Integer id);
}