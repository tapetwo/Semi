<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>

<script>
$(function(){
	fn_searchList();
	fn_uploadList();
	fn_allList();
	fn_write();
})
	
		function fn_uploadList(){	
			$.ajax({	
				type : 'get',
				url : '${contextPath}/upload/ulist',
				dataType: 'json',
				data : 'pageNo=' + ${pageNo} ,
				success: function(resData){
					$('#paging').empty();
					$('#result').empty();
					$.each(resData.uploadList, function( i , uploadList){
						$('<tr>')
						.append( $('<td class="content_line center_font">').text(uploadList.uploadBoardNo) )
						.append( $('<td class="content_line">').append( $('<a>').text(uploadList.uploadTitle).attr('href' ,'${contextPath}/upload/incrase/hit?uploadBoardNo=' + uploadList.uploadBoardNo ) ) )
						.append( $('<td class="content_line center_font">').text(uploadList.createDate) )
						.append( $('<td class="content_line center_font">').text(uploadList.attachCnt) )
						.append( $('<td class="content_line center_font">').text(uploadList.ip) )
						.append( $('<td class="content_line center_font">').text(uploadList.hit) )
						.appendTo('#result');	
					
					})	
					
					var str = '' ;	
			 	    if(resData.beginPage != 1){
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.beginPage -1) + '>' + '◀' + '</a>';
					}  
				 	for(let p = resData.beginPage; p <= resData.endPage; p++){
					 	if(p == resData.page){
					 		str += '<strong>' + p + '</strong>' ;
						}  
						else {
							str += '<a href=${contextPath}/upload/list?pageNo=' + p +'>'+ p + '</a>';
						} 
					} 
					if(resData.endPage != resData.totalPage) {
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.endPage + 1) + '>' + '▶' + '</a>';
						console.log(str);
					}     
					 
					   
					 $('#paging').append(str);   	
				},
				error: function(jqXHR){
					alert('리스트 불러오기가 실패했습니다.');
				}
		})
	}
	
	function fn_searchList(){
		$('#btn_search').click(function (){
			$.ajax({
				type : 'get',
				url : '${contextPath}/upload/search',
				data : 'pageNo=' + ${pageNo} + '&column=' + $('#column').val() + '&query=' + $('#query').val(),
				dataType : 'json',
				success : function (resData){
					console.log(resData)
					$('#paging').empty();
					$('#result').empty();
					
					$.each(resData.uploadList, function( i , uploadList){
						$('<tr>')
						.append( $('<td class="content_line center_font">').text(uploadList.uploadBoardNo) )
						.append( $('<td class="content_line">').append( $('<a>').text(uploadList.uploadTitle).attr('href' ,'${contextPath}/upload/incrase/hit?uploadBoardNo=' + uploadList.uploadBoardNo ) ) )
						.append( $('<td class="content_line center_font">').text(uploadList.createDate) )
						.append( $('<td class="content_line center_font">').text(uploadList.attachCnt) )
						.append( $('<td class="content_line center_font">').text(uploadList.ip) )
						.append( $('<td class="content_line center_font">').text(uploadList.hit) )
						.appendTo('#result');	
					
					})	
					
					var str = '' ;	
			 	    if(resData.beginPage != 1){
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.beginPage -1) + '>' + '◀' + '</a>';
					}  
				 	for(let p = resData.beginPage; p <= resData.endPage; p++){
					 	if(p == resData.page){
					 		str += '<strong>' + p + '</strong>' ;
						}  
						else {
							 str += '<a href=${contextPath}/upload/search?pageNo=' + p + '&column=' + resData.column + '&query=' + resData.query  + '>'+ p + '</a>'; 
						} 
					} 
					if(resData.endPage != resData.totalPage) {
						str += '<a href=${contextPath}/upload/list?pageNo=' + Number(resData.endPage + 1) + '>' + '▶' + '</a>';
						console.log(str);
					}     
					 
					   
					 $('#paging').append(str);   	
				},
				error: function(jqXHR){
					alert('리스트 불러오기가 실패했습니다.');
				
				} 
			})
		})		
	}
	
	function fn_allList(){
		$('#btn_all').click(function (){
			fn_uploadList();	
		})
	}
	
	function fn_write(){
		$('#btn_write').click(function (){
			location.href = '${contextPath}/upload/write';
		})
	}
	
			
			
		
</script>

	<div class="allForm">
		<div class="queryForm">
			<div class="freebrd">
				<div>
				<h2>업로드 게시판</h2>
					<div class="brd_free">
						<div>
							<button id="btn_write" class="btn_primary">게시글 작성<i class="fa-regular fa-pen-to-square"></i></button>
						</div>
						<div>
							<form id="frm_search" action="${contextPath}/upload/search">
								<select id="column" name="column" class="select">
									<option value="">::선택::</option>
									<option value="UPLOAD_TITLE">제목</option>
									<option value="ID">아이디</option>
								</select>
								<span id="area1">
									<input type="text" id="query" name="query" class="input searchBox">
								</span>
								<span>
									<input type="button" value="검색" id="btn_search" class="btn_primary">
									<input type="button" value="전체사원조회" id="btn_all" class="btn_primary"> 
								</span>
							</form>
						</div>
				</div>
				<hr>
				
				<div >
					<table class="freebrd">
						<thead class="brd_free">
							<tr class="title_name">
								<td>NO</td>
								<td>TITLE</td>
								<td>DATE</td>
								<td>FILES</td>
								<td>IP</td>
								<td>HIT</td>
							</tr>
						</thead>
						<tbody id ="result">
						</tbody>
						<tfoot>
							<tr>
								<td colspan="6" id="paging" >
								
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
				
			</div>
		</div>
	</div>
	</div>
</body>
</html>