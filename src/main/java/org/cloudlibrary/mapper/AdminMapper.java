package org.cloudlibrary.mapper;

import org.cloudlibrary.entity.Admin;
import org.apache.ibatis.annotations.Param;

public interface AdminMapper {
    /**
     * 根据用户名查询管理员（含密码，用于登录验证）
     */
    Admin selectByUsername(@Param("username") String username);

    /**
     * 根据ID查询管理员
     */
    Admin selectById(@Param("id") Integer id);
    
    /**
     * 更新管理员信息
     */
    int update(Admin admin);
}