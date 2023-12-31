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
		fn_join();
	});
	
	var emailPass = false;
	
	// 이메일 중복 체크
	function fn_emailCheck(){	
		$('#btn_check').click(function(){
			$.ajax({
				/* 요청 */
				type: 'get',
				url: '${contextPath}/user/checkReduceEmail',
				data: 'email=' + $('#email').val(),
				/* 응답 */
				dataType: 'json',
				success: function(resData){
					// 기존 회원 정보에 등록된 이메일이라면 실패 처리
					if(resData.isUser){
						$('#msg_email').text('이미 사용중인 이메일입니다.');
						emailPass = false;
					} else {
						$('#msg_email').text('사용 가능한 이메일입니다.');
						emailPass = true;
					}
				}
			});
		});
	}
	
	function fn_join(){
		$('#frm_join').submit(function(event){
			if(emailPass == false){
				alert('이메일을 확인하세요.');
				event.preventDefault();
				return;
			}
			if($('#service').is(':checked') == false || $('#privacy').is(':checked') == false){
				alert('필수 약관에 동의하세요.');
				event.preventDefault();
				return;
			}
		});
	}
	
</script>
</head>
<body>

	<div>
	
		<h1>네이버 간편 가입</h1>
	
		<div>* 표시는 필수 입력사항입니다.</div>
		
		<hr>
		
		<form id="frm_join" action="${contextPath}/user/naver/join" method="post">
		
			<!-- 아이디(프로필에 포함-1) -->
			<input type="hidden" name="id" id="id" value="${profile.id}">
			
			<!-- 이름(프로필에 포함-2) -->
			<div>
				<label for="name">이름*</label>
				<input type="text" name="name" id="name" value="${profile.name}">
			</div>
			
			<!-- 성별(프로필에 포함-3) -->
			<div>
				<input type="radio" name="gender" id="none" value="NO" checked="checked">
				<label for="none">선택 안함</label>
				<input type="radio" name="gender" id="male" value="M">
				<label for="male">남자</label>
				<input type="radio" name="gender" id="female" value="F">
				<label for="female">여자</label>
				<script>
					$(':radio[name="gender"][value="${profile.gender}"]').prop('checked', true);
				</script>
			</div>
		
			<!-- 휴대전화(프로필에 포함-4) -->
			<div>
				<label for="mobile">휴대전화*</label>
				<input type="text" name="mobile" id="mobile" value="${profile.mobile}">
			</div>
		
			<!-- 생년월일(프로필에 포함-5) -->
			<div>
				<label for="birthyear">생년월일*</label>
				<input type="text" name="birthyear" id="birthyear" value="${profile.birthyear}">
				<input type="text" name="birthmonth" id="birthmonth" value="${profile.birthday.substring(0,2)}">
				<input type="text" name="birthdate" id="birthdate" value="${profile.birthday.substring(2)}">
			</div>
			
			<!-- 이메일(프로필에 포함-6) -->
			<div>
				<label for="email">이메일*</label>
				<input type="text" name="email" id="email" value="${profile.email}">
				<input type="button" value="중복체크" id="btn_check">
				<span id="msg_email"></span>
			</div>
			
			<hr>
			
			<!-- 약관 -->
			<div>
				<input type="checkbox" id="check_all" class="blind">
				<label for="check_all" class="lbl_all">모두 동의</label>
			</div>
			
			<hr>
			
			<div>
				<input type="checkbox" id="service" class="check_one blind">
				<label for="service" class="lbl_one">이용약관 동의(필수)</label>
				<div>
					<textarea>그냥 동의해</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="privacy" class="check_one blind">
				<label for="privacy" class="lbl_one">개인정보수집 동의(필수)</label>
				<div>
					<textarea>이것도 해라</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="location" name="location" class="check_one blind">
				<label for="location" class="lbl_one">위치정보수집 동의(선택)</label>
				<div>
					<textarea>이건 하던가 말던가</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="promotion" name="promotion" class="check_one blind">
				<label for="promotion" class="lbl_one">마케팅 동의(선택)</label>
				<div>
					<textarea>이것도 맘대로 하셈</textarea>
				</div>
			</div>
			
			<!-- 버튼 -->
			<div>
				<button>가입하기</button>
				<input type="button" value="취소하기" onclick="location.href='${contextPath}'">
			</div>
		
		</form>
	
	</div>

</body>
</html>