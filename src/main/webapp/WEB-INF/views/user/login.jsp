<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>

<style>
	.allForm{
		width : 600px !important;
	}
	.login_text {
		font-size : 20px;
	}
</style>

<script>
	
	$(function(){
		
		fn_login();
		fn_displayRememberId();
		$('.myPage').hide();
	});
	
	function fn_login(){
		
		$('#frm_login').submit(function(event){
			
			if($('#id').val() == '' || $('#pw').val() == ''){
				alert('아이디와 비밀번호를 모두 입력하세요.');
				event.preventDefault();
				return;
			}
			
			if($('#rememberId').is(':checked')){
				$.cookie('rememberId', $('#id').val());
			} else {
				$.cookie('rememberId', '');
			}
			
		});
		
	}
	
	function fn_displayRememberId(){
		
		let rememberId = $.cookie('rememberId');
		if(rememberId == ''){
			$('#id').val('');
			$('#rememberId').prop('checked', false);
		} else {
			$('#id').val(rememberId);
			$('#rememberId').prop('checked', true);
		}
		
	}
	
</script>
</head>
<body>

	<div class="allForm">
		<div class="loginForm">
	
			<h2>로그인</h2>
			
			<form id="frm_login" action="${contextPath}/user/login" method="post">
				
				<input type="hidden" name="url" value="${url}">
				
				<div>
					<label for="id" class="login_text">아이디</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text" class="inputBox" name="id" id="id">
				</div>
				<br>
				<div>
					<label for="pw" class="login_text">비밀번호</label>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="password" class="inputBox" name="pw" id="pw">
				</div>
				
				<div>			
					<button>로그인</button>
				</div>
				
				<div>
					<label for="rememberId">
						<input type="checkbox" id="rememberId">
						아이디 기억
					</label>
					<label for="keepLogin">
						<input type="checkbox" name="keepLogin" id="keepLogin">
						로그인 유지
					</label>
				</div>
			
			</form>
				
			<div>
				<a href="${contextPath}/user/agree">회원가입</a> |
				<a href="${contextPath}/user/findId">아이디 찾기</a> | 
				<a href="${contextPath}/user/findPw">비밀번호 찾기</a>
			</div>
			
			<hr>
			
			<div>
				<a href="${apiURL}"><img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/></a>
			</div>
		</div>
	
	</div>
	
</body>
</html>