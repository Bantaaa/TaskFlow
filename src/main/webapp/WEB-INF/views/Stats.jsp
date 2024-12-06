<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:if test="${sessionScope.user == null}">
<c:redirect url="auth?form=login" />
</c:if>

<c:if test="${sessionScope.user.role == 'INDIVIDUAL'}">
    <c:redirect url="home" />
</c:if>

<jsp:include page="includes/navbar.jsp"/>

<body class="bg-gradient-to-r from-slate-50 to-sky-50">

<h1 class="text-xl font-bold px-8 py-2">STATISTIQUES</h1>

<h2 class="px-8 py-2 text-xs">Porecentage Completion Per Tag</h2>

    <div class="flex mx-8 flex-wrap gap-1">
        <c:forEach var="tag" items="${tags}">
            <div class="flex-shrink-0 m-1 w-[220px] relative overflow-hidden bg-teal-500 rounded-lg max-w-xs shadow-lg group">
                <svg class="absolute bottom-0 left-0 mb-8 scale-150 group-hover:scale-[1.65] transition-transform" viewBox="0 0 375 283" fill="none"
                     style="opacity: 0.1;">
                    <rect x="159.52" y="175" width="152" height="152" rx="8" transform="rotate(-45 159.52 175)" fill="white" />
                    <rect y="107.48" width="152" height="152" rx="8" transform="rotate(-45 0 107.48)" fill="white" />
                </svg>
                <div class="relative text-white px-6 pb-6 mt-6">
                    <span class="block opacity-75 -mb-1">Tag:</span>
                    <div class="flex justify-between">
                        <span class="block font-semibold text-xl">${tag.name}</span>
                        <span class="block bg-white rounded-full text-teal-500 min-w-[50px] text-xs font-bold px-3 py-2 leading-none flex items-center">
                        <fmt:formatNumber value="${CompletPerTag[tag]}" type="number" maxFractionDigits="2" /> %
                    </span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>













<%--<div class="flex items-center bg-white border rounded-sm overflow-hidden shadow">
        <div class="p-4 bg-blue-400"><svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-white" fill="none"
                                          viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2">
            </path>
        </svg></div>
        <div class="px-4 text-gray-700">
            <h3 class="text-sm tracking-wider">Total Post</h3>
            <p class="text-3xl">39,265</p>
        </div>
    </div>
    <div class="flex items-center bg-white border rounded-sm overflow-hidden shadow">
        <div class="p-4 bg-indigo-400"><svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-white" fill="none"
                                            viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z">
            </path>
        </svg></div>
        <div class="px-4 text-gray-700">
            <h3 class="text-sm tracking-wider">Total Comment</h3>
            <p class="text-3xl">142,334</p>
        </div>
    </div>
    <div class="flex items-center bg-white border rounded-sm overflow-hidden shadow">
        <div class="p-4 bg-red-400"><svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-white" fill="none"
                                         viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4">
            </path>
        </svg></div>
        <div class="px-4 text-gray-700">
            <h3 class="text-sm tracking-wider">Server Load</h3>
            <p class="text-3xl">34.12%</p>
        </div>
    </div>--%>

<h2 class="px-8 mt-4 py-2 text-xs">Numbers Of Token Used</h2>

<div class="flex-shrink-0 ml-8 w-[220px] relative overflow-hidden bg-yellow-500 rounded-lg max-w-xs shadow-lg group">
    <svg class="absolute bottom-0 left-0 mb-8 scale-150 group-hover:scale-[1.65] transition-transform" viewBox="0 0 375 283" fill="none"
         style="opacity: 0.1;">
        <rect x="159.52" y="175" width="152" height="152" rx="8" transform="rotate(-45 159.52 175)" fill="white" />
        <rect y="107.48" width="152" height="152" rx="8" transform="rotate(-45 0 107.48)" fill="white" />
    </svg>
    <div class="relative text-white px-6 pb-6 mt-6">
        <span class="block opacity-75 -mb-1">Changing Tasks:</span>
        <div class="flex justify-between">
            <span class="block font-semibold text-md">Tokens Used</span>
            <span class="block bg-white rounded-full text-yellow-900 min-w-[50px] text-xs font-bold px-3 py-2 leading-none flex items-center">
                       ${modificationsTokens} Tk
                    </span>
        </div>
    </div>
</div>


</body>


