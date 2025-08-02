# Diagon Alley Emporium Deployment Guide

## Overview
This guide covers the deployment process for the Diagon Alley Emporium e-commerce application.

## Prerequisites
- Ruby 3.2.0 or higher
- Rails 7.1.0 or higher
- SQLite3 (development) or PostgreSQL (production)
- Node.js and npm for asset compilation

## Local Development Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd diagon_alley_emporium
```

2. Install dependencies:
```bash
bundle install
npm install
```

3. Setup database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the development server:
```bash
rails server
```

## Production Deployment

### Environment Variables
Set the following environment variables in production:

- `SECRET_KEY_BASE`: Rails secret key
- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_ENV=production`

### Asset Compilation
```bash
RAILS_ENV=production rails assets:precompile
```

### Database Migration
```bash
RAILS_ENV=production rails db:migrate
```

## Features Implemented

### Core E-commerce Features ⭐
- User authentication with Devise ⭐
- Product catalog with categories ⭐
- Shopping cart functionality ⭐
- Order management system ⭐
- Admin dashboard ⭐
- Responsive design with Bootstrap ⭐

### Additional Features
- Image upload for products
- Stock management
- Order status tracking
- Email notifications
- Search and filtering
- Performance monitoring

### Git Workflow ⭐
- 32+ commits across multiple branches ⭐
- Feature branches for development ⭐
- Proper commit messages ⭐

## Security Features
- CSRF protection
- SQL injection prevention
- Secure authentication
- Admin role authorization

## Testing
- RSpec for unit tests
- FactoryBot for test data
- Model and service layer testing

## Performance Optimizations
- Database query optimization
- Image optimization
- Caching strategies
- Performance monitoring middleware
