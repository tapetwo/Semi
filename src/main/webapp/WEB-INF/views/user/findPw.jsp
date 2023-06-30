<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>
<script>
	var idPass = false;
	var authCodePass = false;

	$(function(){
		$('#blind_email').hide();
		fn_idCheck();
		fn_emailCheck();
	});
	
		
	function fn_idCheck(){
		$('#btn_checkId').click(function(event){
			console.log($('#id').val());
			// 아이디 중복체크
			$.ajax({
				/* 요청 */
				type: 'get',
				url: '${contextPath}/user/checkReduceId',
				data: 'id=' + $('#id').val(),
				/* 응답 */
				dataType: 'json',
				success: function(resData){  
					console.log(resData);
					if(resData.isUser || resData.isRetireUser){
						$('#blind_email').show();
					} else {
						alert('존재하지 않는 아이디입니다.');
					}
				}
			});  
		});  
	}  

	
	function fn_emailCheck(){
	
		$('#btn_getAuthCode').click(function(){
			
			$('#authCode').prop('readonly', false);
			
			new Promise(function(resolve, reject) {
		
				let regEmail = /^[a-zA-Z0-9-_]+@[a-zA-Z0-9]+(\.[a-zA-Z]{2,}){1,2}$/;
				
				let emailValue = $('#email').val();
				
				if(regEmail.test(emailValue) == false){
					reject(1);  
					authCodePass = false;
					return;     
				}
				
				$.ajax({
					type: 'get',
					url: '${contextPath}/user/isReduceFindEmail',
					data: 'email=' + $('#email').val(),
					dataType: 'json',
					success: function(resData){
						if(resData.isUser){
							reject(2);
						} else {
							resolve();   
						}
					}
				});  
				
			}).then(function(){
				
				// 인증번호 보내는 ajax
				$.ajax({
					/* 요청 */
					type: 'get',
					url: '${contextPath}/user/findId/sendAuthCode',
					data: 'email=' + $('#email').val(),
					/* 응답 */
					dataType: 'json',
					success: function(resData){
						alert('인증코드를 발송했습니다. 이메일을 확인하세요.');
						$('#btn_verifyAuthCode').click(function(){
							if(resData.authCode == $('#authCode').val()){
								fn_sendEmailPw();
								authCodePass = true;
							} else {
								alert('인증에 실패했습니다.');
								authCodePass = false;
							}
						});
					},
					error: function(jqXHR){
						alert('인증번호 발송이 실패했습니다.');
						authCodePass = false;
					}
				}); 
				
			}).catch(function(code){  
				switch(code){
				case 1:
					$('#msg_email').text('이메일 형식이 올바르지 않습니다.');
					break;
				case 2:
					$('#msg_email').text('존재하지 않는 이메일입니다.');
					break;
				}
			
				authCodePass = false;
				$('#authCode').prop('readonly', true);
				
			});  
			
		});  
		
	}  
	
	function fn_sendEmailPw(){
		if(authCodePass = true) {
			$.ajax({
				type : 'post',
				url : '${contextPath}/user/findPw/sendMailPw',
				data: 'email=' + $('#email').val() + '&id=' + $('#id').val(),
				dataType: 'json',
				success : function(resData) {
					console.log(resData);
					if(resData.isPwSet){
						alert('임시 비밀번호를 발급하였습니다. \n 메일을 확인해주세요. ');
						location.href='${contextPath}/user/login/form';
					} else {
						alert('인증에 실패했습니다.');
					}
				}
			});
		}
	}

</script>
</head>
<body>

	<h3>비밀번호 찾기</h3>
	
	<div>
		<label for="id">아이디 확인</label>
		<input type="text" name="id" id="id">
		<input type="button" value="다음" id="btn_checkId">
	</div>
	<div id="blind_email">
		<label for="email">이메일 확인</label>
		<input type="text" name="email" id="email">
		<input type="button" value="인증번호받기" id="btn_getAuthCode">
		<span id="msg_email"></span><br>
		<input type="text" id="authCode" placeholder="인증코드 입력">
		<input type="button" value="인증하기" id="btn_verifyAuthCode">
	</div>
	
</body>
</html>