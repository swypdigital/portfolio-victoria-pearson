// ===================================
// VICTORIA PEARSON PORTFOLIO
// Interactive Elements & Animations
// ===================================

// Theme Toggle
const themeToggle = document.querySelector('.theme-toggle');
const body = document.body;

// Check for saved theme preference or default to dark
const currentTheme = localStorage.getItem('theme') || 'dark';
if (currentTheme === 'light') {
    body.classList.add('light-theme');
}

themeToggle.addEventListener('click', () => {
    body.classList.toggle('light-theme');
    const theme = body.classList.contains('light-theme') ? 'light' : 'dark';
    localStorage.setItem('theme', theme);
});

// Smooth Scroll for Navigation Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const offsetTop = target.offsetTop - 80; // Account for fixed navbar
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

// Scroll-triggered Animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        }
    });
}, observerOptions);

// Observe all elements with animate-on-scroll class
document.querySelectorAll('.animate-on-scroll').forEach(el => {
    observer.observe(el);
});

// Navbar Background on Scroll
const navbar = document.querySelector('.navbar');
let lastScrollY = window.scrollY;

window.addEventListener('scroll', () => {
    if (window.scrollY > 100) {
        navbar.style.background = 'rgba(10, 10, 10, 0.95)';
        navbar.style.boxShadow = '0 4px 6px -1px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.background = 'rgba(10, 10, 10, 0.85)';
        navbar.style.boxShadow = 'none';
    }
    lastScrollY = window.scrollY;
});

// Project Card Tilt Effect (Subtle 3D)
document.querySelectorAll('.project-card').forEach(card => {
    card.addEventListener('mousemove', (e) => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const centerX = rect.width / 2;
        const centerY = rect.height / 2;

        const rotateX = (y - centerY) / 20;
        const rotateY = (centerX - x) / 20;

        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-4px)`;
    });

    card.addEventListener('mouseleave', () => {
        card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) translateY(0)';
    });
});

// Stat Counter Animation
const animateCounter = (element, target) => {
    const duration = 2000; // 2 seconds
    const start = 0;
    const increment = target / (duration / 16); // 60fps
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

// Trigger counter animation when stats come into view
const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const statNumber = entry.target.querySelector('.stat-number');
            const text = statNumber.textContent;

            // Extract number from text like "$25M+" or "100%"
            const match = text.match(/\d+/);
            if (match) {
                const target = parseInt(match[0]);
                const suffix = text.replace(/\d+/, '');
                animateCounter({
                    textContent: '',
                    set textContent(value) {
                        statNumber.textContent = value + suffix;
                    }
                }, target);
            }

            statsObserver.unobserve(entry.target);
        }
    });
}, { threshold: 0.5 });

document.querySelectorAll('.stat-card').forEach(card => {
    statsObserver.observe(card);
});

// Parallax Effect on Hero Background
window.addEventListener('scroll', () => {
    const scrolled = window.scrollY;
    const heroBackground = document.querySelector('.hero-background');
    if (heroBackground && scrolled < window.innerHeight) {
        heroBackground.style.transform = `translateY(${scrolled * 0.5}px)`;
    }
});

// Dynamic Gradient Animation
const heroBackground = document.querySelector('.hero-background');
if (heroBackground) {
    let hue = 0;
    setInterval(() => {
        hue = (hue + 1) % 360;
        // Subtle color shift for background gradients
        heroBackground.style.filter = `hue-rotate(${hue * 0.1}deg)`;
    }, 100);
}

// Add cursor pointer to interactive elements
document.querySelectorAll('.btn, .nav-link, .contact-btn, .theme-toggle').forEach(el => {
    el.style.cursor = 'pointer';
});

// Preload critical fonts
if ('fonts' in document) {
    Promise.all([
        document.fonts.load('400 1rem Montserrat'),
        document.fonts.load('600 1rem Montserrat'),
        document.fonts.load('700 1rem Montserrat'),
        document.fonts.load('800 1rem Montserrat')
    ]).then(() => {
        document.body.style.opacity = '1';
    });
}

// Performance: Debounce scroll events
let scrollTimeout;
window.addEventListener('scroll', () => {
    if (scrollTimeout) {
        window.cancelAnimationFrame(scrollTimeout);
    }
    scrollTimeout = window.requestAnimationFrame(() => {
        // Scroll-based operations here are already optimized above
    });
}, { passive: true });

console.log('%c Victoria Pearson Portfolio ', 'background: linear-gradient(135deg, #339CFF 0%, #0D9488 100%); color: white; font-size: 16px; padding: 10px 20px; border-radius: 8px; font-weight: bold;');
console.log('%c Built with AI-Augmented Development | GroklyGroup Design System ', 'color: #339CFF; font-size: 12px; font-weight: 600;');
