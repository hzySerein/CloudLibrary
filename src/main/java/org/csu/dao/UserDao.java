package org.csu.dao;

import org.csu.pojo.User;

public interface UserDao {
    //查询登录用户的用户名密码是否存在
    public String login(User user);
}
