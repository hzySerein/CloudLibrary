package org.cloudlibrary.view;

/**
 * 个人中心页面视图对象，不包含密码等敏感信息
 */
public class AccountProfileView {
    private Integer id;
    private String username;
    private String name;
    private String phone;
    private String roleName;
    private String avatarIcon;
    private String profileAction;
    private String cancelUrl;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public String getAvatarIcon() { return avatarIcon; }
    public void setAvatarIcon(String avatarIcon) { this.avatarIcon = avatarIcon; }
    public String getProfileAction() { return profileAction; }
    public void setProfileAction(String profileAction) { this.profileAction = profileAction; }
    public String getCancelUrl() { return cancelUrl; }
    public void setCancelUrl(String cancelUrl) { this.cancelUrl = cancelUrl; }
}
