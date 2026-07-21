package org.cloudlibrary.service;

import org.cloudlibrary.entity.Admin;

public interface AdminService {
    Admin login(String username, String password);
    Admin getAdminById(Integer id);
    int updateAdmin(Admin admin);
    void updateProfile(Integer adminId, Admin admin, String oldPassword, String confirmPassword);
}