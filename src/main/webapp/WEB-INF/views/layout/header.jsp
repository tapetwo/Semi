<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/jquery-3.6.1.min.js"></script>
<script src="${contextPath}/resources/js/agree.js"></script>
<script src="${contextPath}/resources/js/jquery-ui.min.js"></script>
<script src="${contextPath}/resources/js/moment-with-locales.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote-lite.css">
<link rel="stylesheet" href="${contextPath}/resources/css/admin.css">
<link rel="stylesheet" href="${contextPath}/resources/css/jquery-ui.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css" integrity="sha512-MV7K8+y+gLIBoVD59lQIYicR65iaqukzvf/nwasF0nqhPay5w/9lJmVM2hMDcnK1OnMGCdVK+iQrJ7lzPJQd1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<header>
	<div class="head_bar">
		<div id="logo_div">
			<a href="${contextPath}"><img id="logo" src="https://www.gdu.co.kr/images/main/logo.png"></a>
		</div>
		<ul class="gnb_barAll">
			<li><a href="${contextPath}/free/list" class="gnb_bar">자유 게시판</a></li>
			<li><span class="snb_bar"></span><a href="${contextPath}/gallery/list" class="gnb_bar">갤러리 게시판</a></li>
			<li><span class="snb_bar"></span><a href="${contextPath}/upload/list"  class="gnb_bar">업로드 게시판</a></li>
			<c:if test="${loginUser.id.equals('admin')}">
				<li><span class="snb_bar"></span><a href="${contextPath}/admin/list/user"  class="gnb_bar">관리 게시판</a></li>
			</c:if>
			<li><span class="snb_bar"></span><a href="${contextPath}/user/check/form" class="gnb_bar">마이페이지</a></li>
		</ul>
	</div>
</header>
<body>
	<br>
	<div class="myPage">
		<c:if test="${loginUser == null}">
			<a href="${contextPath}/user/login/form">로그인페이지</a><br>
		</c:if>
	
		<c:if test="${loginUser != null}">
			<div id="login_info">
				${loginUser.name}님의 보유 포인트 ${loginUser.point}
				<br><a href="${contextPath}/user/logout">로그아웃</a><br>
			</div>

		</c:if>
	</div>