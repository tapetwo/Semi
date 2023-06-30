<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>
<script type="text/javascript">
	$(function(){
		$('#btn_write').click(function (){
			location.href = '${contextPath}/free/write';
		})
		
		$('#btn_first').click(function (){
				location.href = '${contextPath}/free/list';
			})
		
		if('${recordPerPage}' != ''){
			$('#recordPerPage').val(${recordPerPage});			
		} else {
			$('#recordPerPage').val(5);
		}
		
		$('#recordPerPage').change(function(){
			location.href = '${contextPath}/free/list?recordPerPage=' + $(this).val();
		});
		
	});
</script>
<style>
	.lnk_remove {
		cursor: pointer;
	}
	.blind {		
		display: none;
	}
</style>
<style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css');
</style>

	<div class="freebrd">
		<div class="brd_free">
			<h2>자유게시판</h2>
				<button id="btn_write" class="btn_primary">게시글 작성<i class="fa-regular fa-pen-to-square"></i></button> |
				<button id="btn_first" class="btn_primary">첫페이지로<i class="fa-solid fa-rotate-left"></i></button>
	
			<hr>
			
			<div>	
				<select id="recordPerPage">
					<option value="5">5</option>
					<option value="10">10</option>
					<option value="15">15</option>
					<option value="20">20</option>
					<option value="25">25</option>
					<option value="30">30</option>
				</select>
			</div>
		</div>
	</div>

	<div class="freebrd">
		<table class="brd_free" border="0">		
			<thead>
				<tr>
					<th>NO</th>
					<th>ID</th>
					<th>TITLE</th>
					<th>IP</th>
					<th>DATE</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="free" items="${freeBoardList}" varStatus="vs">
					<c:if test="${free.state == 1}">
						<tr>
							<td><center>${beginNo - vs.index}</center></td>
							<td class="center_font">${free.id}</td>
							<td>
								<!-- DEPTH에 따른 들여쓰기 -->
								<c:forEach begin="1" end="${free.depth}" step="1">
									&nbsp;&nbsp;&nbsp;&nbsp;
								</c:forEach>
								<!-- 답글은 [RE] 표시 -->
								<c:if test="${free.depth > 0}">
									<span style="color:tomato"><i class="fa-solid fa-reply fa-rotate-180 fa-xs"></span></i>
								</c:if>
								<!-- 제목 -->			
									${free.freeTitle}
									
								
								
								<!-- 답글달기 버튼 -->
								<c:if test="${loginUser != null}">
									<input type="button" value="reply" class="btn_reply_write">
								</c:if>

								<script>
									$('.btn_reply_write').click(function(){
										$('.reply_write_tr').addClass('blind');
										$(this).parent().parent().next().next().removeClass('blind');
									});
								</script>
							</td>
							
							<td><center>${free.ip}</center></td>
							<td><center>${free.createDate}</center></td>							
							<td><center>
								<form method="post" action="${contextPath}/free/remove">	
									<input type="hidden" name="freeBoardNo" value="${free.freeBoardNo}">
									
									<c:if test="${loginUser.id == free.id}">
										<a class="lnk_remove" id="lnk_remove${free.freeBoardNo}">
											<i class="fa-sharp fa-solid fa-trash "></i>
										</a>
									</c:if>
									
								</form></center></td>
								<script>
									$('#lnk_remove${free.freeBoardNo}').click(function(){
										if(confirm('해당 글을 삭제하시겠습니까? 데이터 삭제시 복구가 불가능합니다.')){
											$(this).parent().submit();
										}		
											
									});
								</script>
							</td>
						</tr>
						
						<tr>
							<!-- 내용 -->
							<td class="content_line" colspan="2"><strong><center>CONTENT</center></strong></td>
							
							<td class="content_line" colspan="3">								
									
									<c:forEach begin="1" end="${free.depth}" step="1">
									&nbsp;&nbsp;&nbsp;&nbsp;
									</c:forEach>
									<!-- 답글은 [RE] 표시 -->
									<c:if test="${free.depth > 0}">
										&nbsp;&nbsp;&nbsp;&nbsp;
									</c:if>
									
									${free.freeContent}
							</td>
							<td class="content_line">
									
									
								<center>
								<form method="get" action="${contextPath}/free/edit">	
									<input type="hidden" name="freeBoardNo" value="${free.freeBoardNo}">
									
									<c:if test="${loginUser.id == free.id}">
										<a class="lnk_edit" id="lnk_edit${free.freeBoardNo}">
											<i class="fa-solid fa-eraser"></i>
										</a>
									</c:if>
									
								</form>
								</center>
								<script>
									$('#lnk_edit${free.freeBoardNo}').click(function(){
										if(confirm('수정 페이지로 이동합니다.')){
											$(this).parent().submit();
										}		
											
									});
								</script>
									
									
							</td>								
						</tr>
					
						
						<tr class="reply_write_tr blind">		
							<td colspan="6">
								<form method="post" action="${contextPath}/free/reply/add">
									<div><input type="text" name="id" value="${loginUser.id}" required readonly></div>
									<div><input type="text" name="freeTitle" placeholder="제목은 필수입니다."  required></div>
									<div><textarea rows="6" cols="22" name="freeContent" placeholder="내용을 입력하세요." required></textarea></div>
									<div><button class="reply">답글작성</button></div>
									<input type="hidden" name="depth" value="${free.depth}">	
									<input type="hidden" name="groupNo" value="${free.groupNo}">
									<input type="hidden" name="groupOrder" value="${free.groupOrder}">
								</form>
							</td>
						<tr>
					</c:if>
					<c:if test="${free.state == 0}">
						<tr>
							<td>${beginNo - vs.index}</td>
							<td colspan="6"><center><font size="4" color="gray">삭제된 게시글입니다.</font></center></td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6">${paging}</td>
				</tr>
			</tfoot>
		</table>
	</div>

</body>
</html>