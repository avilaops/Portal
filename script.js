// ============================================
// AVILA INC PORTAL - JAVASCRIPT
// ============================================

// Mobile Menu Toggle
const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
const navMenu = document.querySelector('.nav-menu');

if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        mobileMenuToggle.classList.toggle('active');
    });
}

// Smooth scroll for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
            // Close mobile menu if open
            if (navMenu.classList.contains('active')) {
                navMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
            }
        }
    });
});

// Navbar scroll effect
let lastScroll = 0;
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 100) {
        navbar.style.boxShadow = '0 4px 6px -1px rgb(0 0 0 / 0.1)';
    } else {
        navbar.style.boxShadow = 'none';
    }

    lastScroll = currentScroll;
});

// Intersection Observer for fade-in animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Apply fade-in to product cards
document.querySelectorAll('.product-card').forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(30px)';
    card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
    observer.observe(card);
});

// Apply fade-in to tech items
document.querySelectorAll('.tech-item').forEach((item, index) => {
    item.style.opacity = '0';
    item.style.transform = 'scale(0.9)';
    item.style.transition = `opacity 0.5s ease ${index * 0.05}s, transform 0.5s ease ${index * 0.05}s`;
    observer.observe(item);
});

// Contact Form Handler
const contactForm = document.getElementById('contactForm');

if (contactForm) {
    contactForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const formData = new FormData(contactForm);
        const data = Object.fromEntries(formData);

        // Show loading state
        const submitBtn = contactForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Enviando...';
        submitBtn.disabled = true;

        // Call Avila API
        try {
            const response = await fetch('https://avila-api.thankfulcoast-72fb953d.eastus.azurecontainerapps.io/api/v1/contact', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (response.ok && result.success) {
                alert('✅ Mensagem enviada com sucesso! Entraremos em contato em breve.');
                contactForm.reset();
            } else {
                throw new Error(result.message || 'Erro ao enviar mensagem');
            }
        } catch (error) {
            console.error('Contact form error:', error);
            alert('❌ Erro ao enviar mensagem. Tente novamente mais tarde ou envie email para contato@avila.inc');
        } finally {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        }
    });
}

// Product Cards - Click to expand
document.querySelectorAll('.product-card').forEach(card => {
    card.addEventListener('click', (e) => {
        // Don't trigger if clicking on a link
        if (e.target.tagName === 'A') return;

        // Add pulse animation
        card.style.animation = 'pulse 0.3s ease';
        setTimeout(() => {
            card.style.animation = '';
        }, 300);
    });
});

// Hero Stats Counter Animation
const animateCounter = (element, target, duration = 2000) => {
    const start = 0;
    const increment = target / (duration / 16);
    let current = start;

    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            element.textContent = target;
            clearInterval(timer);
        } else {
            element.textContent = Math.floor(current);
        }
    }, 16);
};

// Trigger counter animation when hero is visible
const heroStatsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const statNumbers = document.querySelectorAll('.stat-number');
            statNumbers.forEach(stat => {
                const text = stat.textContent;
                if (!isNaN(parseFloat(text))) {
                    const value = parseFloat(text);
                    animateCounter(stat, value);
                }
            });
            heroStatsObserver.disconnect();
        }
    });
}, { threshold: 0.5 });

const heroStats = document.querySelector('.hero-stats');
if (heroStats) {
    heroStatsObserver.observe(heroStats);
}

// Parallax effect for hero background
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const heroBackground = document.querySelector('.hero-background');
    if (heroBackground && scrolled < window.innerHeight) {
        heroBackground.style.transform = `translateY(${scrolled * 0.5}px)`;
    }
});

// Product status indicator - simulate real-time updates
const updateProductStatus = () => {
    const statusIndicators = document.querySelectorAll('.product-status');

    // In a real application, this would fetch actual status from API
    statusIndicators.forEach(indicator => {
        // Simulate checking status
        const isOnline = Math.random() > 0.1; // 90% uptime simulation

        if (isOnline) {
            indicator.textContent = '● Online';
            indicator.classList.add('online');
        } else {
            indicator.textContent = '● Manutenção';
            indicator.classList.remove('online');
        }
    });
};

// Update status every 30 seconds
setInterval(updateProductStatus, 30000);

// Dynamic gradient animation for hero title
const gradientText = document.querySelector('.gradient-text');
if (gradientText) {
    let hue = 0;
    setInterval(() => {
        hue = (hue + 1) % 360;
        gradientText.style.filter = `hue-rotate(${hue}deg)`;
    }, 50);
}

// Console Easter Egg
console.log('%c🚀 Avila Inc - Portal', 'font-size: 24px; font-weight: bold; color: #6366f1;');
console.log('%cInteressado em trabalhar conosco?', 'font-size: 14px; color: #6b7280;');
console.log('%cEnvie seu currículo para: carreiras@avila.inc', 'font-size: 14px; color: #10b981;');

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.02); }
    }

    .nav-menu.active {
        display: flex;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        flex-direction: column;
        padding: 20px;
        box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
    }

    .mobile-menu-toggle.active span:nth-child(1) {
        transform: rotate(45deg) translate(5px, 5px);
    }

    .mobile-menu-toggle.active span:nth-child(2) {
        opacity: 0;
    }

    .mobile-menu-toggle.active span:nth-child(3) {
        transform: rotate(-45deg) translate(7px, -6px);
    }
`;
document.head.appendChild(style);

// Performance optimization - Lazy load images (if any are added later)
if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.classList.remove('lazy');
                observer.unobserve(img);
            }
        });
    });

    document.querySelectorAll('img.lazy').forEach(img => {
        imageObserver.observe(img);
    });
}

// Track scroll depth for analytics (placeholder)
let maxScrollDepth = 0;
window.addEventListener('scroll', () => {
    const scrollDepth = (window.pageYOffset + window.innerHeight) / document.body.scrollHeight;
    if (scrollDepth > maxScrollDepth) {
        maxScrollDepth = scrollDepth;
        // TODO: Send to analytics
        // analytics.track('scroll_depth', { depth: Math.round(maxScrollDepth * 100) });
    }
});

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('✅ Portal Avila Inc loaded successfully');

    // Add loaded class for CSS transitions
    document.body.classList.add('loaded');
});
