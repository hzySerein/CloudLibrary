package org.cloudlibrary.mapper;

import org.cloudlibrary.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    User selectByUsername(@Param("username") String username);
    User selectById(@Param("id") Integer id);
    List<User> selectByPage(@Param("offset") int offset, @Param("size") int size);
    List<User> searchUsers(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);
    int countTotalUser();
    int countSearchUsers(@Param("keyword") String keyword);
    List<User> selectActiveUsers(@Param("limit") int limit); // 活跃用户排行榜
    int insert(User user);
    int update(User user);
    int deleteById(Integer id);
}