class Toast {
    constructor() {
        this.container = this.createContainer();
    }

    createContainer() {
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
        return container;
    }

    show(message, type = 'info', title = '') {
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };

        const titles = {
            success: title || '成功',
            error: title || '错误',
            warning: title || '警告',
            info: title || '提示'
        };

        // 安全构建DOM，防止XSS
        const iconSpan = document.createElement('span');
        iconSpan.className = 'toast-icon';
        iconSpan.textContent = icons[type];

        const contentDiv = document.createElement('div');
        contentDiv.className = 'toast-content';

        const titleDiv = document.createElement('div');
        titleDiv.className = 'toast-title';
        titleDiv.textContent = titles[type];

        const msgDiv = document.createElement('div');
        msgDiv.className = 'toast-message';
        msgDiv.textContent = message;

        contentDiv.appendChild(titleDiv);
        contentDiv.appendChild(msgDiv);

        const closeBtn = document.createElement('button');
        closeBtn.className = 'toast-close';
        closeBtn.innerHTML = '&times;';
        closeBtn.addEventListener('click', () => this.hide(toast));

        toast.appendChild(iconSpan);
        toast.appendChild(contentDiv);
        toast.appendChild(closeBtn);

        this.container.appendChild(toast);

        setTimeout(() => {
            this.hide(toast);
        }, 5000);

        return toast;
    }

    hide(toast) {
        toast.style.animation = 'toastSlideOut 0.3s ease-out forwards';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }

    success(message, title) {
        return this.show(message, 'success', title);
    }

    error(message, title) {
        return this.show(message, 'error', title);
    }

    warning(message, title) {
        return this.show(message, 'warning', title);
    }

    info(message, title) {
        return this.show(message, 'info', title);
    }
}

class Modal {
    constructor(options = {}) {
        this.id = options.id || 'modal-' + Date.now();
        this.title = options.title || '';
        this.content = options.content || '';
        this.footer = options.footer || '';
        this.onConfirm = options.onConfirm || null;
        this.onCancel = options.onCancel || null;
        this.showClose = options.showClose !== false;
        this.size = options.size || '';
        this.element = null;
    }

    create() {
        const modal = document.createElement('div');
        modal.className = 'modal';
        modal.id = this.id;
        modal.setAttribute('role', 'dialog');
        modal.setAttribute('aria-modal', 'true');

        let sizeClass = '';
        if (this.size === 'small') sizeClass = 'modal-sm';
        if (this.size === 'large') sizeClass = 'modal-lg';
        if (this.size === 'extra-large') sizeClass = 'modal-xl';

        // 安全构建DOM，title使用textContent防止XSS
        const contentDiv = document.createElement('div');
        contentDiv.className = `modal-content ${sizeClass}`;

        const headerDiv = document.createElement('div');
        headerDiv.className = 'modal-header';

        const titleH3 = document.createElement('h3');
        titleH3.className = 'modal-title';
        titleH3.id = this.id + '-title';
        modal.setAttribute('aria-labelledby', titleH3.id);
        titleH3.textContent = this.title;  // textContent 防止XSS
        headerDiv.appendChild(titleH3);

        if (this.showClose) {
            const closeBtn = document.createElement('button');
            closeBtn.className = 'modal-close';
            closeBtn.innerHTML = '&times;';
            headerDiv.appendChild(closeBtn);
        }

        const bodyDiv = document.createElement('div');
        bodyDiv.className = 'modal-body';
        // content 支持 DOM Node 或纯文本
        if (this.content instanceof Node) {
            bodyDiv.appendChild(this.content);
        } else {
            bodyDiv.textContent = this.content != null ? this.content : '';
        }

        const footerDiv = document.createElement('div');
        footerDiv.className = 'modal-footer';
        if (this.footer instanceof Node) {
            footerDiv.appendChild(this.footer);
        } else if (this.footer) {
            footerDiv.textContent = this.footer;
        } else {
            var defaultCancel = document.createElement('button');
            defaultCancel.className = 'btn btn-outline modal-cancel';
            defaultCancel.textContent = '取消';
            var defaultConfirm = document.createElement('button');
            defaultConfirm.className = 'btn btn-primary modal-confirm';
            defaultConfirm.textContent = '确定';
            footerDiv.appendChild(defaultCancel);
            footerDiv.appendChild(defaultConfirm);
        }

        contentDiv.appendChild(headerDiv);
        contentDiv.appendChild(bodyDiv);
        contentDiv.appendChild(footerDiv);
        modal.appendChild(contentDiv);

        this.element = modal;
        this.bindEvents();

        return modal;
    }

    bindEvents() {
        const closeBtn = this.element.querySelector('.modal-close');
        const cancelBtn = this.element.querySelector('.modal-cancel');
        const confirmBtn = this.element.querySelector('.modal-confirm');

        if (closeBtn) {
            closeBtn.addEventListener('click', () => this.hide());
        }

        if (cancelBtn) {
            cancelBtn.addEventListener('click', () => {
                if (this.onCancel) {
                    this.onCancel();
                }
                this.hide();
            });
        }

        if (confirmBtn) {
            confirmBtn.addEventListener('click', () => {
                if (this.onConfirm) {
                    const result = this.onConfirm();
                    if (result !== false) {
                        this.hide();
                    }
                } else {
                    this.hide();
                }
            });
        }

        this.element.addEventListener('click', (e) => {
            if (e.target === this.element) {
                this.hide();
            }
        });

        this._keydownHandler = (e) => {
            if (e.key === 'Escape' && this.element && this.element.classList.contains('show')) {
                this.hide();
            }
        };
        document.addEventListener('keydown', this._keydownHandler);
    }

    show() {
        if (!this.element) {
            this.create();
            document.body.appendChild(this.element);
        }
        setTimeout(() => {
            this.element.classList.add('show');
        }, 10);
        return this;
    }

    hide() {
        if (this.element) {
            this.element.classList.remove('show');
        }
        return this;
    }

    setContent(content) {
        this.content = content;
        const body = this.element.querySelector('.modal-body');
        if (body) {
            body.innerHTML = '';
            if (content instanceof Node) {
                body.appendChild(content);
            } else {
                body.textContent = content != null ? content : '';
            }
        }
        return this;
    }

    setTitle(title) {
        this.title = title;
        const titleEl = this.element.querySelector('.modal-title');
        if (titleEl) {
            titleEl.textContent = title;
        }
        return this;
    }

    setFooter(footer) {
        this.footer = footer;
        const footerEl = this.element.querySelector('.modal-footer');
        if (footerEl) {
            footerEl.innerHTML = '';
            if (footer instanceof Node) {
                footerEl.appendChild(footer);
            } else {
                footerEl.textContent = footer != null ? footer : '';
            }
            this.bindEvents();
        }
        return this;
    }

    destroy() {
        if (this._keydownHandler) {
            document.removeEventListener('keydown', this._keydownHandler);
            this._keydownHandler = null;
        }
        if (this.element && this.element.parentNode) {
            this.element.parentNode.removeChild(this.element);
        }
        this.element = null;
    }

    static _buildFooterButtons(buttons) {
        var wrapper = document.createElement('div');
        buttons.forEach(function(cfg) {
            var btn = document.createElement('button');
            btn.className = cfg.className;
            btn.textContent = cfg.text;
            wrapper.appendChild(btn);
        });
        return wrapper;
    }

    static confirm(message, options = {}) {
        const footer = Modal._buildFooterButtons([
            { className: 'btn btn-outline modal-cancel', text: '取消' },
            { className: 'btn btn-primary modal-confirm', text: '确定' }
        ]);
        return new Promise((resolve) => {
            const modal = new Modal({
                title: options.title || '确认',
                content: message,
                footer: footer,
                onConfirm: () => {
                    if (typeof options.onConfirm === 'function') {
                        options.onConfirm();
                    }
                    modal.destroy();
                    resolve(true);
                },
                onCancel: () => {
                    if (typeof options.onCancel === 'function') {
                        options.onCancel();
                    }
                    modal.destroy();
                    resolve(false);
                }
            });
            modal.show();
        });
    }

    static alert(message, options = {}) {
        const footer = Modal._buildFooterButtons([
            { className: 'btn btn-primary modal-confirm', text: '确定' }
        ]);
        return new Promise((resolve) => {
            const modal = new Modal({
                title: options.title || '提示',
                content: message,
                footer: footer,
                onConfirm: () => {
                    modal.destroy();
                    resolve();
                }
            });
            modal.show();
        });
    }
}

class FormValidator {
    constructor(form, options = {}) {
        this.form = typeof form === 'string' ? document.querySelector(form) : form;
        this.rules = options.rules || {};
        this.messages = options.messages || {};
        this.onSubmit = options.onSubmit || null;
        this.init();
    }

    init() {
        if (!this.form) return;

        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            if (this.validate()) {
                if (this.onSubmit) {
                    this.onSubmit(this.form);
                } else {
                    this.form.submit();
                }
            }
        });

        const inputs = this.form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', () => this.validateField(input));
            input.addEventListener('input', () => {
                if (input.classList.contains('is-invalid')) {
                    this.validateField(input);
                }
            });
        });
    }

    validateField(field) {
        const name = field.name;
        if (!name || !this.rules[name]) return true;

        const rules = this.rules[name];
        const value = field.value.trim();
        let isValid = true;
        let message = '';

        for (const rule of rules) {
            if (rule.required && !value) {
                isValid = false;
                message = rule.message || this.messages[name]?.required || '此字段为必填项';
                break;
            }

            if (rule.minLength && value.length < rule.minLength) {
                isValid = false;
                message = rule.message || this.messages[name]?.minLength || `最少需要${rule.minLength}个字符`;
                break;
            }

            if (rule.maxLength && value.length > rule.maxLength) {
                isValid = false;
                message = rule.message || this.messages[name]?.maxLength || `最多允许${rule.maxLength}个字符`;
                break;
            }

            if (rule.pattern && !rule.pattern.test(value)) {
                isValid = false;
                message = rule.message || this.messages[name]?.pattern || '格式不正确';
                break;
            }

            if (rule.email && !this.validateEmail(value)) {
                isValid = false;
                message = rule.message || this.messages[name]?.email || '请输入有效的邮箱地址';
                break;
            }

            if (rule.phone && !this.validatePhone(value)) {
                isValid = false;
                message = rule.message || this.messages[name]?.phone || '请输入有效的手机号码';
                break;
            }
        }

        this.setFieldStatus(field, isValid, message);
        return isValid;
    }

    validate() {
        let isValid = true;
        const inputs = this.form.querySelectorAll('input, select, textarea');

        inputs.forEach(input => {
            if (input.name && this.rules[input.name]) {
                if (!this.validateField(input)) {
                    isValid = false;
                }
            }
        });

        return isValid;
    }

    setFieldStatus(field, isValid, message) {
        field.classList.remove('is-valid', 'is-invalid');

        let feedback = field.nextElementSibling;
        if (!feedback || !feedback.classList.contains('invalid-feedback')) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            field.parentNode.insertBefore(feedback, field.nextSibling);
        }

        if (isValid) {
            field.classList.add('is-valid');
            feedback.textContent = '';
        } else {
            field.classList.add('is-invalid');
            feedback.textContent = message;
        }
    }

    validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    validatePhone(phone) {
        return /^1[3-9]\d{9}$/.test(phone);
    }

    reset() {
        this.form.reset();
        const inputs = this.form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.classList.remove('is-valid', 'is-invalid');
            const feedback = input.nextElementSibling;
            if (feedback && feedback.classList.contains('invalid-feedback')) {
                feedback.textContent = '';
            }
        });
    }
}

const toast = new Toast();

window.addEventListener('DOMContentLoaded', () => {
    const toastStyles = document.createElement('style');
    toastStyles.textContent = `
        @keyframes toastSlideOut {
            from {
                opacity: 1;
                transform: translateX(0);
            }
            to {
                opacity: 0;
                transform: translateX(100%);
            }
        }
    `;
    document.head.appendChild(toastStyles);
});
