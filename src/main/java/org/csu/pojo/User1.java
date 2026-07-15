package org.csu.pojo;

public class User1 {
    private int id;
    private String name;
    private String password;

    //通过构造方法注入属性值
    public User1(int userId, String name, String password) {
        this.id = userId;
        this.name = name;
        this.password = password;
    }

}
