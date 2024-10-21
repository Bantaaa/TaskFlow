<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded shadow-md w-96">
    <h2 class="text-2xl font-bold mb-4">Register</h2>
    <form action="${pageContext.request.contextPath}/auth/register" method="post">      <div class="mb-4">
        <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username:</label>
        <input type="text" id="username" name="username" required class="w-full px-3 py-2 border rounded-lg">
      </div>
      <div class="mb-4">
        <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
        <input type="email" id="email" name="email" required class="w-full px-3 py-2 border rounded-lg">
      </div>
      <div class="mb-4">
        <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password:</label>
        <input type="password" id="password" name="password" required class="w-full px-3 py-2 border rounded-lg">
      </div>
      <div class="mb-6">
        <label for="role" class="block text-gray-700 text-sm font-bold mb-2">Role:</label>
        <select id="role" name="role" required class="w-full px-3 py-2 border rounded-lg bg-white">
          <option value="USER">User</option>
          <option value="MANAGER">Manager</option>
        </select>
      </div>
      <div class="flex items-center justify-between">
        <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Register</button>
        <a href="${pageContext.request.contextPath}/login.jsp" class="text-blue-500 hover:underline">Login</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>