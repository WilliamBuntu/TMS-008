// Form validation functions
const validateForm = {
    password: (password) => {
        return password.length >= 6;
    },

    confirmPassword: (password, confirmPassword) => {
        return password === confirmPassword;
    },

    email: (email) => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
};

// Toast notification system
const showToast = (message, type = 'info') => {
    const toastContainer = document.getElementById('toast-container')
        || createToastContainer();

    const toast = document.createElement('div');
    toast.className = `toast show alert alert-${type}`;
    toast.role = 'alert';
    toast.innerHTML = message;

    toastContainer.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
};

const createToastContainer = () => {
    const container = document.createElement('div');
    container.id = 'toast-container';
    container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 1050;';
    document.body.appendChild(container);
    return container;
};

// AJAX utility functions
const ajax = {
    post: async (url, data) => {
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });
            return await response.json();
        } catch (error) {
            console.error('Error:', error);
            showToast('An error occurred', 'danger');
            throw error;
        }
    },

    get: async (url) => {
        try {
            const response = await fetch(url);
            return await response.json();
        } catch (error) {
            console.error('Error:', error);
            showToast('An error occurred', 'danger');
            throw error;
        }
    }
};

// Form handling
document.addEventListener('DOMContentLoaded', () => {
    // Registration form validation
    const registrationForm = document.querySelector('form[action*="/auth/register"]');
    if (registrationForm) {
        registrationForm.addEventListener('submit', (e) => {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const email = document.getElementById('email').value;

            if (!validateForm.password(password)) {
                e.preventDefault();
                showToast('Password must be at least 6 characters long', 'danger');
                return;
            }

            if (!validateForm.confirmPassword(password, confirmPassword)) {
                e.preventDefault();
                showToast('Passwords do not match', 'danger');
                return;
            }

            if (!validateForm.email(email)) {
                e.preventDefault();
                showToast('Please enter a valid email address', 'danger');

            }
        });
    }
});

// Task management functions
const taskManager = {
    toggleTaskStatus: async (taskId) => {
        try {
            const response = await ajax.post(`/tasks/toggle/${taskId}`);
            if (response.success) {
                showToast('Task status updated', 'success');
                return true;
            }
            return false;
        } catch (error) {
            showToast('Failed to update task status', 'danger');
            return false;
        }
    },

    deleteTask: async (taskId) => {
        if (confirm('Are you sure you want to delete this task?')) {
            try {
                const response = await ajax.post(`/tasks/delete/${taskId}`);
                if (response.success) {
                    showToast('Task deleted successfully', 'success');
                    document.querySelector(`[data-task-id="${taskId}"]`)?.remove();
                    return true;
                }
                return false;
            } catch (error) {
                showToast('Failed to delete task', 'danger');
                return false;
            }
        }
    }
};

// Category management functions
const categoryManager = {
    deleteCategory: (categoryId) => {
        if (confirm('Are you sure you want to delete this category?')) {
            window.location.href = `/categories/delete?id=${categoryId}`;
        }
    }
};

// UI helper functions
const ui = {
    togglePasswordVisibility: (inputId, buttonId) => {
        const input = document.getElementById(inputId);
        const button = document.getElementById(buttonId);

        if (input && button) {
            const type = input.type === 'password' ? 'text' : 'password';
            input.type = type;
            button.innerHTML = type === 'password' ?
                '<i class="fas fa-eye"></i>' :
                '<i class="fas fa-eye-slash"></i>';
        }
    },

    initializeTooltips: () => {
        const tooltipTriggerList = [].slice.call(
            document.querySelectorAll('[data-bs-toggle="tooltip"]')
        );
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
};

// Initialize tooltips when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    ui.initializeTooltips();
});