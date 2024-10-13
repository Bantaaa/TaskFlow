<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to Task Manager</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex flex-col items-center justify-center">
  <h1 class="text-4xl font-bold mb-4">Welcome to Task Manager</h1>
  <p class="text-xl mb-8">Manage your tasks efficiently and collaborate with your team.</p>
  <div class="space-x-4">
    <a href="${pageContext.request.contextPath}/auth/login" class="bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600">Login</a>
    <a href="${pageContext.request.contextPath}/auth/register" class="bg-green-500 text-white px-6 py-3 rounded hover:bg-green-600">Register</a>
  </div>
</div>
</body>
</html>