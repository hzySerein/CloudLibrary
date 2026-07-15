package org.csu.dao.imp;

import org.csu.dao.UserDao;
import org.csu.pojo.User;
import org.springframework.stereotype.Repository;


/**
 * @author hzy213
 * @data 2025.11.16
 */

@Repository("userDao")
public class UserDaoImp implements UserDao {
    @Override
    public String login(User user) {
        System.out.println("根据客户端传递来的的用户户名为：" + user.getUserName()+"，密码为："+user.getPassword()+"进行了数据库验证");
        return "登陆成功";
    }
}




