<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded shadow-md w-96">
    <h2 class="text-2xl font-bold mb-4">Login</h2>
    <form action="${pageContext.request.contextPath}/auth/login" method="post">
      <div class="mb-4">
        <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username:</label>
        <input type="text" id="username" name="username" required class="w-full px-3 py-2 border rounded-lg">
      </div>
      <div class="mb-6">
        <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password:</label>
        <input type="password" id="password" name="password" required class="w-full px-3 py-2 border rounded-lg">
      </div>
      <div class="flex items-center justify-between">
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Login</button>
        <a href="${pageContext.request.contextPath}/auth/register" class="text-blue-500 hover:underline">Register</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>