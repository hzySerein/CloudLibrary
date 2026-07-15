package org.csu.pojo;


import org.csu.controller.UserController;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

class UserTest {

    public static void main(String[] args) {

        //初始化spring容器，加载applicationContext.xml配置
        ApplicationContext applicationContext=new ClassPathXmlApplicationContext("applicationContext.xml");
        //通过容器获取配置中user的实例
        User user= (User)applicationContext.getBean("user");
        //打印user对象的属性值,toString()方法
        System.out.println(user);

        //通过容器获取配置中userController的实例
        UserController userController= (UserController)applicationContext.getBean("userController");

        String result=userController.login(user);
        System.out.println(result);
    }

}