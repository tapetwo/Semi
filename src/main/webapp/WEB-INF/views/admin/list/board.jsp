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
		fn_deleteSelectBoard();
		
		$('.start_datepicker').datepicker({
			dateFormat: 'yymmdd',  // 실제로는 yyyymmdd로 적용됨
			changeMonth: true,
	      	changeYear: true
		});
		
		$('.end_datepicker').datepicker({
			dateFormat: 'yymmdd',  // 실제로는 yyyymmdd로 적용됨
			changeMonth: true,
	      	changeYear: true
		});
		
		$('#btn_admin').click(function(){
			location.href='${contextPath}/admin/list/user';
			
		});
		
	});

	function fn_autoList(){
		
		$('#boardList, #span_cnt').empty();
		$.ajax({
			type : 'get',
			url : '${contextPath}/admin/list/allBoards',
			data : 'page=' + <%=p%>,
			dataType : 'json',
			success : function(resData) {
				
				$('<span>').html('총 게시글 : ' + resData.totalRecord +  '개')
				.appendTo('#span_cnt');
				
				$('.pageWrap').html(resData.paging);
				
				if(resData.status == 200) {
					$('#board_type').show();

					$.each(resData.boards, function(i, board){

						var tr = $('<tr>');
						
						tr
						.append($('<td class="center">').html('<input type="checkbox" class="check_board" name="id" value="'+ board.id +'">'))
						.append($('<td class="center">').html((resData.totalRecord - board.rn + 1)));
						
						if(board.freeBoardNo != 0) {
							tr
							.append($('<td>').text(board.freeBoardNo).addClass('blind'))
							.append($('<td>').html('<input type="hidden" name="board" value="FREE_BOARD">' + '자유게시판'))
						} else if(board.galleryBoardNo != 0){
							tr
							.append($('<td>').text(board.galleryBoardNo).addClass('blind'))
							.append($('<td class="center">').html('<input type="hidden" name="board" value="GALLERY_BOARD">' + '갤러리게시판'))
						} else if(board.uploadBoardNo != 0){
							tr
							.append($('<td>').text(board.uploadBoardNo).addClass('blind'))
							.append($('<td class="center">').html('<input type="hidden" name="board" value="UPLOAD_BOARD">' + '업로드게시판'))
						}
						
						tr
						.append($('<td class="center title">').html(board.title))
						.append($('<td class="center">').html(board.id))
						.append($('<td class="center">').html(board.ip))
						.append($('<td class="center">').html(board.createDate))
						.append($('<td class="center">').html(board.hit))
						.appendTo($('#boardList'));
						
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
			$('#boardList, #span_cnt').empty();
			
			if($('#query').val() == '' && $('#first').val() == '' && $('#last').val() == '' && $('#start').val() == '' && $('#stop').val() == '') {
				$('#column').val('');
			};
			
			$.ajax({
				type : 'get',
				url : '${contextPath}/admin/list/searchBoards',
				data : $('#frm_search').serialize(),
				dataType : 'json',
				success : function(resData) {
					
					$('#board_type').hide();
					
					$('<span>').html('총 게시글 : ' + resData.totalRecord + '개')
					.appendTo('#span_cnt');
					
					$('.pageWrap').html(resData.paging);
					
					if(resData.status == 200) {
						
						$.each(resData.boards, function(i, board){
							var tr = $('<tr>');
							
							tr
							.append($('<td class="center">').html('<input type="checkbox" class="check_board" name="id" value="'+ board.id +'">'))
							.append($('<td class="center">').html((resData.totalRecord - board.rn + 1)));
							
							if(board.freeBoardNo != 0) {
								$('#board_type').show();
								tr
								.append($('<td>').text(board.freeBoardNo).addClass('blind'))
								.append($('<td>').html('<input type="hidden" name="board" value="FREE_BOARD">' + '자유게시판'))
							} else if(board.galleryBoardNo != 0){
								$('#board_type').show();
								tr
								.append($('<td>').text(board.galleryBoardNo).addClass('blind'))
								.append($('<td class="center">').html('<input type="hidden" name="board" value="GALLERY_BOARD">' + '갤러리게시판'))
							} else if(board.uploadBoardNo != 0){
								$('#board_type').show();
								tr
								.append($('<td>').text(board.uploadBoardNo).addClass('blind'))
								.append($('<td class="center">').html('<input type="hidden" name="board" value="UPLOAD_BOARD">' + '업로드게시판'))
							}
							
							tr
							.append($('<td class="center title">').html(board.title))
							.append($('<td class="center">').html(board.id))
							.append($('<td class="center">').html(board.ip))
							.append($('<td class="center">').html(board.createDate))
							.append($('<td class="center">').html(board.hit))
							.appendTo($('#boardList'));
						});
					} else {
						alert(resData.message);
					}
				}
			});
		});
	}
	
	function fn_deleteSelectBoard(){
		
		var id = new Array();
		var boardNo = new Array();
		var board = new Array();
		$(document).on('click', '.check_board', function(event){
			if($(this).is(":checked")) {
				id.push($(this).val());
				boardNo.push($(this).parent().next().next().text());
				board.push($(this).parent().next().next().next().children().first().val());
			} else if($(this).is(":checked") == false){
				for(var i = 0; i < id.length; i++){
					if($(this).val() == id[i]){
						id.splice(i, 1);
						boardNo.splice(i, 1);
						board.splice(i, 1);
					}
				}
			}
		});
		
		var objParams = {
                "id"      : id,
                "boardNo" : boardNo,
                "board"   : board
            };
		
		$('.delete_icon').click(function() {
			if(confirm('체크한 항목을 삭제하시겠습니까?')){
				$.ajax({
					type : 'post',
					url : '${contextPath}/admin/board/remove',
					data : objParams,
					dataType : 'json',
					success : function(resData){
						alert(resData.message);
						fn_autoList();
						id = [];
						boardNo = [];
						board = [];
					}
				})
			}
		})
	}
	
	function fn_inputShow(){
		
		$('#area2').hide();
		$('#area3').hide();
		
		$('#area2').css('display', 'none');

		$('#column').change(function(){
			$('.input').val('');
			let combo = $(this);
			if(combo.val() == 'CREATE_DATE'){
				$('#area1').hide();
				$('#area2').hide();
				$('#area3').show();
			} else {
				$('#area1').show();
				$('#area2').hide();
				$('#area3').hide();
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
				<select id="board" name="board" class="select">
					<option value="">전체</option>
					<option value="FREE_BOARD">자유게시판</option>
					<option value="GALLERY_BOARD">사진게시판</option>
					<option value="UPLOAD_BOARD">업로드게시판</option>
				</select>
				<select id="column" name="column" class="select">
					<option value="">:::선택:::</option>
					<option value="ID">작성자</option>
					<option value="TITLE">제목</option>
					<option value="CONTENT">내용</option>
					<option value="TITLE_CONTENT">제목 + 내용</option>
					<option value="CREATE_DATE">작성일자</option>
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
					<button class="delete_icon"><i class="fa-solid fa-trash-can"></i></button>
				</span>
			</form>
		</div>
			<table class="tbl_board">
				<thead class="head_font thead_board">
					<tr>
						<td class="choice">선택</td>
						<td class="no">순번</td>
						<td id="board_type">종류</td>
						<td class="title_tr">제목</td>
						<td class="id">아이디</td>
						<td class="ip">IP</td>
						<td class="date">작성일자</td>
						<td class="hit">조회수</td>
					</tr>
				</thead>
				
				<tbody id="boardList">
				</tbody>
			</table>
		<div>
			<button class="btn_primary" id="btn_admin">유저 관리</button>
		</div>
		<div class="paginate">
			<div class="pageWrap">
				${paging}
			</div>
		</div>
	</div>
</body>
</html>