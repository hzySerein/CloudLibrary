package org.csu.service;


import org.csu.pojo.User;

/**
 * 负责处理用户相关的业务逻辑,主要负责用户相关的业务逻辑的处理
 * @author hzy213
 * @data 2025.11.15
 */
public interface UserService {
    public String login(User user);
}
