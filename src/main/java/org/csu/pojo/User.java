package org.csu.pojo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 用户实体类,封装客户请求到服务器的用户信息
 * @author hzy
 * @data 2025.11.15
 */

@Component
public class User {
    //用户ID
    @Value(value = "241130")
    private int userId;

    //用户名
    @Value(value = "hzy213")
    private String userName;

    //密码
    @Value(value = "123456")
    private String password;


    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", userName='" + userName + '\'' +
                ", password='" + password + '\'' +
                '}';
    }

    //通过get/set注入属性值
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;

    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
        System.out.println("调用setUserName方法");
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


}
