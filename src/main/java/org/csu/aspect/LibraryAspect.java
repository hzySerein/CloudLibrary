package org.csu.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;


/**
 * @author hzy213
 * @data 2025.11.16
 * 图书馆切面类,负责检测用户的权限与用户操作日志记录
 * 目标对象是org.csu.dao.imp.UserDaoImp类,需要将权限检测的方法增强到目标对象的login方法中
 *
 * 1定义增强方法
 *
 */
@Aspect
@Component
public class LibraryAspect {

    @Pointcut("execution(* org.csu.controller.UserController.login(..))")
    public void pointcut() {

    }

    @Before("pointcut()")

    //权限检测方法
    public void before(JoinPoint joinPoint) {
        System.out.println("模拟权限检测");
    }


}
