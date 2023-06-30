<%@page import="java.util.Optional"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<% 	Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
	int p = Integer.parseInt(opt.orElse("1")); 
%>

<jsp:include page="../../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>
<script>

	$(function(){
		
		var id;
		
		fn_autoList();
		fn_searchList();
		fn_inputShow();
		fn_removeUser();
		fn_dormantUser();
		fn_restoreUser();
		fn_infoUser();
		
		$('.start_datepicker').datepicker({
			dateFormat: 'yymmdd',  
			changeMonth: true,
	      	changeYear: true
		});
		$('.end_datepicker').datepicker({
			dateFormat: 'yymmdd', 
			changeMonth: true,
	      	changeYear: true
		});
		
		$('#btn_admin').click(function(){
			location.href='${contextPath}/admin/list/board';
			
		});
	});

	function fn_autoList(){
		$('#userList, #span_cnt').empty();
		$.ajax({
			type : 'get',
			url : '${contextPath}/admin/list/allUsers',
			data : 'page=' + <%=p%>,
			dataType : 'json',
			success : function(resData) {
				
				$('<span>').html('총 인원 수 : ' + resData.totalRecord)
				.append($('<span>').html('&nbsp;&nbsp;정상 회원 : ' + resData.userCnt))
				.append($('<span>').html('&nbsp;&nbsp;휴면 회원 : ' + resData.sleepUserCnt))
				.appendTo('#span_cnt');
				
				$('.pageWrap').html(resData.paging);
				
				if(resData.status == 200) {

					$.each(resData.users, function(i, user){

						$('<tr>')
						.append($('<td class="center">').html(user.rn))
						.append($('<td class="center id">').html($('<span class="user_info">').text(user.userDTO.id)))
						.append($('<td class="blind">').text('detail'))
						.append(user.sleepUserDTO.sleepDate == null ? $('<td class="center">').html('정상회원') : $('<td class="center">').html('휴면회원'))
						.append($('<td class="center">').html(user.userDTO.point))
						.append(user.userDTO.snsType == null ? $('<td class="center">').html('자체 회원') : $('<td class="center">').html('Naver 가입'))
						.append($('<td class="center">').html(user.userDTO.joinDate))
						.append($('<td class="center">').html(user.userDTO.accessLogDTO.lastLoginDate))
						.append(user.userDTO.infoModifyDate == null ? $('<td class="center">').html('') : $('<td class="center">').html(user.userDTO.infoModifyDate))
						.append(user.sleepUserDTO.sleepDate == null ? $('<td class="center">').html('') : $('<td class="sleepUser center">').html(user.sleepUserDTO.sleepDate))
						.append($('<td class="center">').html('<a class="dormant_icon"><i class="fa-solid fa-user-check"></i></a>'))
						.append($('<td class="center">').html('<a class="restore_icon"><i class="fa-solid fa-user-lock"></i></a>'))
						.append($('<td class="center">').html('<a class="retire_icon"><i class="fa-solid fa-trash-can"></i></a>'))
						.appendTo($('#userList'));
						
					});
				} else {
					alert(resData.message);
				}
			}
		});
	};
	
	function fn_searchList(){
		$('#btn_all').click(function(){
			fn_autoList();
		});
		
		$('#btn_search').click(function(){
			$('#userList, #span_cnt').empty();
			
			if($('#query').val() == '' && $('#first').val() == '' && $('#last').val() == '' && $('#start').val() == '' && $('#stop').val() == '') {
				$('#column').val('');
			};
			var sleep = $('#sleepData');
			var modiDate = $('#modifyData');
			
			if($('#state').val() == '') {
				modiDate.show();
				sleep.show();
			} else {
				if($('#state').val() == 'active'){
					if($('#column').val() == 'SLEEP_DATE'){
						$('#column').val('');
					}
					sleep.hide();
					modiDate.show();
				} else {
					sleep.show();
					modiDate.hide();
				}
			};
			
			$.ajax({
				type : 'get',
				url : '${contextPath}/admin/list/searchUsers',
				data : $('#frm_search').serialize(),
				dataType : 'json',
				success : function(resData) {
					var sleepCnt = '';
					if($('#state').val() == '') {
						sleepCnt = '&nbsp;&nbsp;휴면 회원 : ' + resData.sleepUserCnt;
					}
					$('<span>').html('총 인원 수 : ' + resData.totalRecord)
					.append($('<span>').html(sleepCnt))
					.appendTo('#span_cnt');
					
					$('.pageWrap').html(resData.paging);
					
					if(resData.status == 200) {
						$.each(resData.users, function(i, user){
							var tr = $('<tr>');

							tr
							.append($('<input type="hidden">').val())
							.append($('<td class="center">').html(user.rn))
							.append($('<td class="center id">').html($('<span class="info_user">').text(user.userDTO.id)))
							.append($('<td class="blind">').text('detail'))
							.append($('<td class="blind">').text(user.sleepUserDTO.sleepDate == null ? '정상회원' : '휴면회원'))
							.append(user.sleepUserDTO.sleepDate == null ? $('<td class="center">').html('정상회원') : $('<td class="center">').html('휴면회원'))
							.append($('<td class="center">').html(user.userDTO.point))
							.append(user.userDTO.snsType == null ? $('<td class="center">').html('자체 회원') : $('<td class="center">').html('Naver 가입'))
							.append($('<td class="center">').html(user.userDTO.joinDate))
							.append($('<td class="center">').html(user.userDTO.accessLogDTO.lastLoginDate));
							if($('#state').val() == ''){
								tr
								.append(user.userDTO.infoModifyDate == null ?  $('<td class="center">').html('') : $('<td class="center">').html(user.userDTO.infoModifyDate))
								.append(user.sleepUserDTO.sleepDate == null ? $('<td class="center">').html('') : $('<td class="sleepUser center">').html(user.sleepUserDTO.sleepDate))
							}else{
								tr
								.append(user.sleepUserDTO.sleepDate == null ? $('<td class="center">').html(user.userDTO.infoModifyDate) : $('<td class="sleepUser center">').html(user.sleepUserDTO.sleepDate))
							}
							tr
							.append($('<td class="center">').html('<a class="dormant_icon"><i class="fa-solid fa-user-check"></i></a>'))
							.append($('<td class="center">').html('<a class="restore_icon"><i class="fa-solid fa-user-lock"></i></a>'))
							.append($('<td class="center">').html('<a class="retire_icon"><i class="fa-solid fa-trash-can"></i></a>'))
							tr.appendTo($('#userList'));
							
						});
					} else {
						alert(resData.message);
					}
				}
			});
		});
	}
	
	function fn_removeUser(){
		var userType = '';
		$(document).on('click', '.retire_icon', function(event){
			id = $(this).parent().parent().children().first().next().text();
			if(confirm(id + '회원을 삭제하시겠습니까?')){
				
				if($(this).parent().prev().prev().prev().hasClass('sleepUser')){
					userType = 'SLEEP_USERS';
				} else {
					userType = 'USERS';
				}
				
				$.ajax({
					type : 'post',
					url : '${contextPath}/admin/user/retire',
					data : 'userType=' + userType + '&id=' + id,
					dataType : 'json',
					success : function(resData){
						alert(resData.message);
						fn_autoList();
					}
				});	
				
			};	
		});	
	}	
	
	function fn_dormantUser(){
		$(document).on('click', '.dormant_icon', function(event){
			id = $(this).parent().parent().children().first().next().text();
			
			if(confirm(id + '회원을 휴면 회원으로 전환 하시겠습니까?')){
				
				if($(this).parent().prev().hasClass('sleepUser')){
					alert('이미 휴면 회원입니다.');
					event.preventDefault();
					return;
					
				} else {
					
					$.ajax({
						type : 'post',
						url : '${contextPath}/admin/user/dormant',
						data : 'id=' + id,
						dataType : 'json',
						success : function(resData){
							alert(resData.message);
							fn_autoList();
						}
					});
				};
			};
		});
	};
	
	function fn_restoreUser(){
		$(document).on('click', '.restore_icon', function(event){
			id = $(this).parent().parent().children().first().next().text();
			if(confirm(id + '회원을 정상 회원으로 전환 하시겠습니까?')){
				if($(this).parent().prev().prev().hasClass('sleepUser')){
					
					$.ajax({
						type : 'post',
						url : '${contextPath}/admin/user/restore',
						data : 'id=' + id,
						dataType : 'json',
						success : function(resData){
							alert(resData.message);
							fn_autoList();
						}
					});
					
				} else {
					
					alert('이미 정상 회원입니다.');
					event.preventDefault();
					return;
				
				};
			};
		});
	};
	
	function fn_infoUser(){
		$(document).on('click', '.user_info', function(event){
			var id = $(this).text();
			var detail = $(this).parent().next().text();
			var state = $(this).parent().next().next().text();
			location.href="${contextPath}/admin/user/detail?id=" + id + "&type=" + detail + "&state=" + state;
		})
	};
	
	function fn_inputShow(){
		
		$('#area2').hide();
		$('#area3').hide();
		
		$('#area2').css('display', 'none');

		$('#column').change(function(){
			$('.input').val('');
			let combo = $(this);
			if(combo.val() == 'ID' || combo.val() == ''){
				$('#area1').show();
				$('#area2').hide();
				$('#area3').hide();
			} else if(combo.val() == 'POINT'){
				$('#area1').hide();
				$('#area2').show();
				$('#area3').hide();
			} else {
				$('#area1').hide();
				$('#area2').hide();
				$('#area3').show();
			}
		});
	};
</script>

	<div class="allForm">
		<div class="queryForm">
			<div class="cnt_div">
				<span id="span_cnt"></span>
			</div>
			<form id="frm_search">
				<select id="state" name="state" class="select">
					<option value="">전체</option>
					<option value="active">정상회원</option>
					<option value="sleep">휴면회원</option>
				</select>
				<select id="column" name="column" class="select">
					<option value="">:::선택:::</option>
					<option value="ID">아이디</option>
					<option value="JOIN_DATE">가입일</option>
					<option id="sleepOpt" value="SLEEP_DATE">휴면일자</option>
					<option value="POINT">포인트</option>
				</select>
				<input type="hidden" name="page" value="<%=p%>">
				<span id="area1">
					<input type="text" id="query" name="query" class="input searchBox">
				</span>
				<span id="area2">
					<input type="text" id="first" name="first" class="input searchBox">
					~
					<input type="text" id="last" name="last" class="input searchBox">
				</span>
				<span id="area3">
					<input type="text" id="start" name="start" class="start_datepicker input searchBox">
					~
					<input type="text" id="stop" name="stop" class="end_datepicker input searchBox">
				</span>
				<span>
					<input type="button" value="검색" id="btn_search" class="btn_primary">
					<input type="button" value="전체회원조회" id="btn_all" class="btn_primary">
				</span>
			</form>
		</div>
		<table class="tbl_user">
			<thead class="head_font thead_user">
				<tr>
					<td>순번</td>
					<td>아이디</td>
					<td>상태</td>
					<td>포인트</td>
					<td>가입종류</td>
					<td>가입일</td>
					<td>마지막접속일</td>
					<td id="modifyData">정보변경일</td>
					<td id="sleepData">휴면날짜</td>
					<td>휴면전환</td>
					<td>휴면해제</td>
					<td>강제탈퇴</td>
				</tr>
			</thead>
			<tbody id="userList">
			</tbody>
		</table>
		<div>
			<button class="btn_primary" id="btn_admin">게시글 관리</button>
		</div>
		<div class="paginate">
			<div class="pageWrap">
				${paging}
			</div>
		</div>
	</div>
</body>
</html>