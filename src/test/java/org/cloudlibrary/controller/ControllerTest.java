package org.cloudlibrary.controller;

import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.entity.User;
import org.cloudlibrary.filter.CsrfFilter;
import org.cloudlibrary.service.AdminService;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.service.UserService;
import org.cloudlibrary.util.CsrfUtil;
import org.cloudlibrary.view.AccountProfileView;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Controller regression tests — standalone MockMvc with mocked services.
 * Covers: login view role params, profile view data, sensitive field exposure,
 * shared view names, and POST-only modify endpoints.
 */
public class ControllerTest {

    private MockMvc adminMvc;
    private MockMvc userMvc;
    private MockMvc borrowMvc;

    private AdminService adminService;
    private UserService userService;
    private BookService bookService;
    private org.cloudlibrary.service.BorrowService borrowService;

    @Before
    public void setUp() {
        adminService = mock(AdminService.class);
        userService = mock(UserService.class);
        bookService = mock(BookService.class);
        borrowService = mock(org.cloudlibrary.service.BorrowService.class);

        AdminLoginController adminLoginCtrl = new AdminLoginController();
        inject(adminLoginCtrl, "adminService", adminService);

        UserLoginController userLoginCtrl = new UserLoginController();
        inject(userLoginCtrl, "userService", userService);

        UserBorrowController borrowCtrl = new UserBorrowController();
        inject(borrowCtrl, "borrowService", borrowService);
        inject(borrowCtrl, "bookService", bookService);

        adminMvc = MockMvcBuilders.standaloneSetup(adminLoginCtrl)
                .addFilter(new CsrfFilter(), "/*").build();
        userMvc = MockMvcBuilders.standaloneSetup(userLoginCtrl)
                .addFilter(new CsrfFilter(), "/*").build();
        borrowMvc = MockMvcBuilders.standaloneSetup(borrowCtrl)
                .addFilter(new CsrfFilter(), "/*").build();
    }

    private static void inject(Object target, String field, Object value) {
        org.springframework.test.util.ReflectionTestUtils.setField(target, field, value);
    }

    /** Create a session with a valid CSRF token, and return the token for POST param. */
    private static String[] csrfSessionAndToken(MockHttpSession session) {
        String token = CsrfUtil.generateToken();
        session.setAttribute(CsrfUtil.CSRF_TOKEN_ATTR, token);
        return new String[]{CsrfUtil.CSRF_PARAM_NAME, token};
    }

    // ==================== Admin Login: shared view + role params ====================

    @Test
    public void adminLogin_returnsSharedViewWithAdminRole() throws Exception {
        adminMvc.perform(get("/admin/toLogin"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/login"))
                .andExpect(model().attribute("role", "admin"))
                .andExpect(model().attribute("roleName", "管理员"))
                .andExpect(model().attribute("loginAction", "/admin/login"))
                .andExpect(model().attribute("pageTitle", "管理员登录"));
    }

    @Test
    public void adminLogin_success_redirectsToIndex() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);

        when(adminService.login("admin", "pass")).thenReturn(makeAdmin(1, "admin"));

        adminMvc.perform(post("/admin/login")
                        .param("username", "admin")
                        .param("password", "pass")
                        .param(csrf[0], csrf[1])
                        .session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/index"));
    }

    @Test
    public void adminLogin_failure_returnsViewWithError() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);

        when(adminService.login("admin", "wrong")).thenReturn(null);

        adminMvc.perform(post("/admin/login")
                        .param("username", "admin")
                        .param("password", "wrong")
                        .param(csrf[0], csrf[1])
                        .session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/login"))
                .andExpect(model().attribute("msg", "用户名或密码错误！"))
                .andExpect(model().attribute("role", "admin"));
    }

    // ==================== Admin Profile: shared view + sensitive field check ====================

    @Test
    public void adminProfile_noSession_redirectsToLogin() throws Exception {
        adminMvc.perform(get("/admin/profile"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/toLogin"));
    }

    @Test
    public void adminProfile_returnsSharedViewWithAdminData() throws Exception {
        Admin admin = makeAdmin(1, "admin");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginAdmin", admin);
        when(adminService.getAdminById(1)).thenReturn(admin);

        adminMvc.perform(get("/admin/profile").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("account/profile"))
                .andExpect(model().attribute("role", "admin"))
                .andExpect(model().attributeExists("accountProfile"));
    }

    @Test
    public void adminProfile_viewDoesNotExposePassword() throws Exception {
        Admin admin = makeAdmin(1, "admin");
        admin.setPassword("secret-hash");

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginAdmin", admin);
        when(adminService.getAdminById(1)).thenReturn(admin);

        String body = adminMvc.perform(get("/admin/profile").session(session))
                .andReturn().getResponse().getContentAsString();

        assertFalse("password must not leak", body.contains("secret-hash"));
    }

    @Test
    public void accountProfileView_hasNoPasswordField() throws Exception {
        AccountProfileView view = new AccountProfileView();
        try {
            view.getClass().getDeclaredField("password");
            fail("AccountProfileView must not have a password field");
        } catch (NoSuchFieldException expected) { }
        try {
            view.getClass().getDeclaredMethod("getPassword");
            fail("AccountProfileView must not have getPassword()");
        } catch (NoSuchMethodException expected) { }
    }

    // ==================== Admin: modify endpoints POST-only ====================

    @Test
    public void adminUpdateProfile_postWithSession_redirects() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);
        session.setAttribute("loginAdmin", makeAdmin(1, "admin"));

        adminMvc.perform(post("/admin/profile")
                        .session(session)
                        .param(csrf[0], csrf[1])
                        .param("name", "newName"))
                .andExpect(status().is3xxRedirection());
    }

    // ==================== User Login: shared view + role params ====================

    @Test
    public void userLogin_returnsSharedViewWithUserRole() throws Exception {
        userMvc.perform(get("/user/toLogin"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/login"))
                .andExpect(model().attribute("role", "user"))
                .andExpect(model().attribute("roleName", "用户"))
                .andExpect(model().attribute("loginAction", "/user/login"))
                .andExpect(model().attribute("pageTitle", "用户登录"));
    }

    @Test
    public void userLogin_success_redirectsToBorrowApply() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);

        when(userService.login("testuser", "pass")).thenReturn(makeUser(1, "testuser"));

        userMvc.perform(post("/user/login")
                        .param("username", "testuser")
                        .param("password", "pass")
                        .param(csrf[0], csrf[1])
                        .session(session))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/user/borrow/apply"));
    }

    @Test
    public void userLogin_failure_returnsViewWithError() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);

        when(userService.login("testuser", "wrong")).thenReturn(null);

        userMvc.perform(post("/user/login")
                        .param("username", "testuser")
                        .param("password", "wrong")
                        .param(csrf[0], csrf[1])
                        .session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/login"))
                .andExpect(model().attribute("msg", "用户名或密码错误！"))
                .andExpect(model().attribute("role", "user"));
    }

    // ==================== User Profile: shared view + sensitive field check ====================

    @Test
    public void userProfile_noSession_redirectsToLogin() throws Exception {
        userMvc.perform(get("/user/profile"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/user/toLogin"));
    }

    @Test
    public void userProfile_returnsSharedViewWithUserData() throws Exception {
        User user = makeUser(1, "testuser");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginUser", user);
        when(userService.getUserById(1)).thenReturn(user);

        userMvc.perform(get("/user/profile").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("account/profile"))
                .andExpect(model().attribute("role", "user"))
                .andExpect(model().attributeExists("accountProfile"));
    }

    @Test
    public void userProfile_viewDoesNotExposePassword() throws Exception {
        User user = makeUser(1, "testuser");
        user.setPassword("secret-hash");

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginUser", user);
        when(userService.getUserById(1)).thenReturn(user);

        String body = userMvc.perform(get("/user/profile").session(session))
                .andReturn().getResponse().getContentAsString();

        assertFalse("password must not leak", body.contains("secret-hash"));
    }

    // ==================== User: modify endpoints POST-only ====================

    @Test
    public void userUpdateProfile_postWithSession_redirects() throws Exception {
        MockHttpSession session = new MockHttpSession();
        String[] csrf = csrfSessionAndToken(session);
        session.setAttribute("loginUser", makeUser(1, "testuser"));

        userMvc.perform(post("/user/profile")
                        .session(session)
                        .param(csrf[0], csrf[1])
                        .param("name", "newName"))
                .andExpect(status().is3xxRedirection());
    }

    // ==================== Borrow Apply: shared view + model data ====================

    @Test
    public void userBorrowApply_noSession_redirectsToLogin() throws Exception {
        borrowMvc.perform(get("/user/borrow/apply"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/user/toLogin"));
    }

    @Test
    public void userBorrowApply_returnsSharedViewWithModelData() throws Exception {
        User user = makeUser(1, "testuser");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginUser", user);
        when(bookService.countTotalBook()).thenReturn(0);

        borrowMvc.perform(get("/user/borrow/apply").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("borrow/apply"))
                .andExpect(model().attribute("role", "user"))
                .andExpect(model().attribute("roleName", "用户"))
                .andExpect(model().attribute("applyUrl", "/user/borrow/apply"))
                .andExpect(model().attribute("detailUrl", "/user/borrow/book/detail/"))
                .andExpect(model().attribute("currentDate", java.time.LocalDate.now().toString()));
    }

    @Test
    public void userBorrowApply_modelContainsAccount() throws Exception {
        User user = makeUser(1, "testuser");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loginUser", user);
        when(bookService.countTotalBook()).thenReturn(0);

        borrowMvc.perform(get("/user/borrow/apply").session(session))
                .andExpect(model().attributeExists("account"))
                .andExpect(model().attribute("account", user));
    }

    // ==================== Helpers ====================

    private static Admin makeAdmin(int id, String username) {
        Admin a = new Admin();
        a.setId(id);
        a.setUsername(username);
        a.setName("Admin " + id);
        a.setPhone("1380000000" + id);
        return a;
    }

    private static User makeUser(int id, String username) {
        User u = new User();
        u.setId(id);
        u.setUsername(username);
        u.setName("User " + id);
        u.setPhone("1390000000" + id);
        return u;
    }
}
