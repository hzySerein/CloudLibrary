package org.csu.service.imp;

import org.csu.dao.UserDao;
import org.csu.pojo.User;
import org.csu.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;


@Service(value = "userService")

public class UserServiceImp implements UserService {

    @Resource(name = "userDao")
    private UserDao userDao;


    @Override
    public String login(User user) {
        System.out.println("UserService进行了数据验证");
        String loginResult = userDao.login(user);
        return loginResult;
    }


}
