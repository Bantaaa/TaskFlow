<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>


<link rel="stylesheet" href="https://demos.creative-tim.com/notus-js/assets/styles/tailwind.css">
<link rel="stylesheet" href="https://demos.creative-tim.com/notus-js/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
<c:set var="user" value="${sessionScope.user}" />
<c:choose>
<c:when test="${not empty user}">

<main class="profile-page ">
    <section class="relative block h-72">
        <div class="absolute top-0 w-full h-full bg-center bg-cover" style="
            background-image: url('https://images.unsplash.com/photo-1499336315816-097655dcfbda?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=2710&amp;q=80');
          ">
            <span id="blackOverlay" class="w-full h-full absolute opacity-50 bg-black"></span>
        </div>
        <div class="top-auto bottom-0 left-0 right-0 w-full absolute pointer-events-none overflow-hidden h-70-px" style="transform: translateZ(0px)">
            <svg class="absolute bottom-0 overflow-hidden" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" version="1.1" viewBox="0 0 2560 100" x="0" y="0">
                <polygon class="text-blueGray-200 fill-current" points="2560 0 2560 100 0 100"></polygon>
            </svg>
        </div>
    </section>
    <section class="relative py-16 bg-blueGray-200 min-h-80">
        <div class="container mx-auto px-4">
            <div class="relative flex flex-col min-w-0 break-words bg-white  w-full mb-6 shadow-xl rounded-lg -mt-64 min-h-96">
                <div class="px-6">
                    <div class="flex flex-wrap justify-center">
                        <div class="w-full lg:w-3/12 px-4 lg:order-2 flex justify-center">
                            <div class="relative">
                                <img alt="..." src="https://th.bing.com/th/id/OIP.PoS7waY4-VeqgNuBSxVUogAAAA?rs=1&pid=ImgDetMain" class="shadow-xl rounded-full h-auto align-middle border-none absolute -m-16 -ml-20 lg:-ml-16 max-w-150-px">
                            </div>
                        </div>
                        <div class="w-full lg:w-4/12 px-4 lg:order-3 lg:text-right lg:self-center">
                            <div class="py-6 px-3 mt-32 sm:mt-0">
                                <button data-modal-target="popup-modal" data-modal-toggle="popup-modal"  class="bg-slate-700 active:bg-slate-500 uppercase text-white font-bold hover:shadow-md shadow text-xs px-4 py-2 rounded outline-none focus:outline-none sm:mr-2 mb-1 ease-linear transition-all duration-150" type="button">
                                    Update
                                </button>

                                <div id="popup-modal" tabindex="-1" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
                                    <div class="relative p-4 w-full max-w-md max-h-full">
                                        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                                            <!-- Close Button -->
                                            <button type="button" class="absolute top-3 right-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="popup-modal">
                                                <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                                </svg>
                                                <span class="sr-only">Close modal</span>
                                            </button>

                                            <div class="p-6 md:p-8">
                                                <h3 class="mb-5 text-md font-semibold text-gray-900 dark:text-gray-300 text-left">Update Your Details</h3>

                                                <form action="users" method="post">
                                                    <input type="hidden" name="action" value="updateUser">
                                                    <input type="hidden" name="userId" value="${user.id}">
                                                    <div class="flex gap-6">
                                                    <div class="mb-6">
                                                        <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 text-left">First Name</label>
                                                        <input type="text" id="firstName" name="firstName" value="${user.firstName}"
                                                               class="mt-2 block w-full rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 text-dark p-2.5">
                                                    </div>

                                                    <div class="mb-6">
                                                        <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 text-left">Last Name</label>
                                                        <input type="text" id="lastName" name="lastName" value="${user.lastName}"
                                                               class="mt-2 block w-full rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 text-dark p-2.5">
                                                    </div>
                                                    </div>

                                                    <div class="mb-6">
                                                        <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 text-left">Email</label>
                                                        <input type="email" id="email" name="email" value="${user.email}"
                                                               class="mt-2 block w-full rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 text-dark p-2.5">
                                                    </div>

                                                    <div class="flex justify-between items-center">
                                                        <button type="submit" class="text-white bg-slate-800 hover:bg-slate-900 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-md text-sm px-5 py-2.5 text-center  dark:focus:ring-blue-800">Update</button>
                                                        <button type="button" data-modal-hide="popup-modal" class="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">Cancel</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                            </div>
                        </div>
                        <div class="w-full lg:w-4/12 px-4 lg:order-1">
                            <div class="flex justify-center py-4 lg:pt-4 pt-8">
                                <div class="mr-4 p-3 text-center">
                                    <span class="text-xl font-bold block uppercase tracking-wide text-blueGray-600">22</span><span class="text-sm text-blueGray-400">Friends</span>
                                </div>
                                <div class="mr-4 p-3 text-center">
                                    <span class="text-xl font-bold block uppercase tracking-wide text-blueGray-600">10</span><span class="text-sm text-blueGray-400">Photos</span>
                                </div>
                                <div class="lg:mr-4 p-3 text-center">
                                    <span class="text-xl font-bold block uppercase tracking-wide text-blueGray-600">89</span><span class="text-sm text-blueGray-400">Comments</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-12">
                        <h3 class="text-4xl font-semibold leading-normal mb-2 text-blueGray-700 mb-2">
                                ${user.firstName.toUpperCase()}  ${user.lastName.toUpperCase()}
                        </h3>
                        <div class="text-sm leading-normal mt-0 mb-2 text-blueGray-400 font-bold uppercase">
                                ${user.username}
                        </div>
                        <div class="mb-2 text-blueGray-600 mt-10">
                            <i class="fas fa-briefcase mr-2 text-lg text-blueGray-400"></i>Email - ${user.email}
                        </div>
                        <div class="mb-2 text-blueGray-600">
                            <i class="fas fa-university mr-2 text-lg text-blueGray-400"></i>Member Since ${user.registeredAt}
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>
</main>
</c:when>
</c:choose>
<script src="https://cdn.jsdelivr.net/npm/flowbite@2.5.2/dist/flowbite.min.js"></script>
</body>
</html>
