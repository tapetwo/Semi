<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>
<script>

	$(function(){
		fn_emailCheck();
	});
	
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
								alert('인증되었습니다. \n 아이디는 ' + resData.userId + '입니다.');
								location.href='${contextPath}/user/login/form';
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

</script>
</head>
<body>

	<h3>아이디 찾기</h3>
	
	<div>
		<label for="email">이메일 확인</label>
		<input type="text" name="email" id="email">
		<input type="button" value="인증번호받기" id="btn_getAuthCode">
		<span id="msg_email"></span><br>
		<input type="text" id="authCode" placeholder="인증코드 입력">
		<input type="button" value="인증하기" id="btn_verifyAuthCode">
	</div>
	
	<div>
		
	</div>
	
</body>
</html>