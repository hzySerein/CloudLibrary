package org.csu.controller;


import com.sun.org.apache.xpath.internal.operations.Bool;
import org.csu.pojo.User;
import org.csu.service.UserService;
import org.csu.service.imp.UserServiceImp;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;

/**
 * 负责处理客户端提交的用户相关的请求处理
 * 承担控制器的角色
 * @author hzy
 * @data 2025.11.16
 */

@Controller

public class UserController {

    @Resource(name = "userService")



    private UserService userService;

    public String login(User user){
        return userService.login(user);
    }


    public void setUserService(UserServiceImp userService) {
        this.userService = userService;
    }

}
