<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register Page</title>
</head>
<body>
<div class="font-[sans-serif]">
  <div class="min-h-screen flex flex-col items-center justify-center py-6 px-4">
    <div class="grid md:grid-cols-2 items-center gap-10 max-w-6xl w-full">
      <div>
        <h2 class="lg:text-5xl text-4xl font-extrabold lg:leading-[55px] text-gray-800">
          Join Seamless Projects and Tasks Management
        </h2>
        <p class="text-sm mt-6 text-gray-800">Sign up and start managing your projects effortlessly today.</p>
        <p class="text-sm mt-12 text-gray-800">
          Already have an account?
          <a href="auth?form=login" class="text-blue-600 font-semibold hover:underline ml-1">Sign in here</a>
        </p>
      </div>

      <form action="auth" method="post" class="max-w-md md:ml-auto w-full">
        <h3 class="text-gray-800 text-3xl font-extrabold mb-8">Register</h3>
        <input type="hidden" name="form" value="register" />

        <div class="space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <input name="firstName" type="text" required class="bg-gray-100 w-full text-sm text-gray-800 px-4 py-3.5 rounded-md outline-blue-600 focus:bg-transparent" placeholder="First Name" />
            </div>
            <div>
              <input name="lastName" type="text" required class="bg-gray-100 w-full text-sm text-gray-800 px-4 py-3.5 rounded-md outline-blue-600 focus:bg-transparent" placeholder="Last Name" />
            </div>
          </div>
          <div>
            <input name="email" type="email" autocomplete="email" required class="bg-gray-100 w-full text-sm text-gray-800 px-4 py-3.5 rounded-md outline-blue-600 focus:bg-transparent" placeholder="Email address" />
          </div>

          <div>
            <input name="password" type="password" autocomplete="new-password" required class="bg-gray-100 w-full text-sm text-gray-800 px-4 py-3.5 rounded-md outline-blue-600 focus:bg-transparent" placeholder="Password" />
          </div>

          <c:if test="${not empty errorMessage}">
            <p class="text-red-500">${errorMessage}</p>
          </c:if>

          <c:if test="${not empty success}">
            <p class="text-slate-500">${success}</p>
          </c:if>

        </div>

        <div class="!mt-8">
          <button type="submit" class="w-full shadow-xl py-2.5 px-4 text-sm font-semibold rounded text-white bg-blue-600 hover:bg-blue-700 focus:outline-none">
            Register
          </button>
        </div>

      </form>
    </div>
  </div>
</div>
</body>
</html>
