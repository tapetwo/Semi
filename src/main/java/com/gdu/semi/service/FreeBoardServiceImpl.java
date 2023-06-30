package com.gdu.semi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.gdu.semi.domain.FreeBoardDTO;
import com.gdu.semi.mapper.FreeBoardMapper;
import com.gdu.semi.util.FreePageUtil;
import com.gdu.semi.util.SecurityUtil;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class FreeBoardServiceImpl implements FreeBoardService {

	private FreeBoardMapper freeBoardMapper;
	private FreePageUtil pageUtil;
	private SecurityUtil securityUtil;		// 타이틀에 적용

	@Override
	public void findAllFreeList(HttpServletRequest request, Model model) {
		
		Optional<String> opt1 = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt1.orElse("1"));
		
		Optional<String> opt2 = Optional.ofNullable(request.getParameter("recordPerPage"));
		int recordPerPage = Integer.parseInt(opt2.orElse("5"));

		// 전체 게시글 개수
		int totalRecord = freeBoardMapper.selectAllFreeCount();
		
		// 페이징에 필요한 모든 계산 완료
		pageUtil.setPageUtil(page, recordPerPage, totalRecord);
		
		// DB로 보낼 Map(begin + end)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		// DB에서 목록 가져오기
		List<FreeBoardDTO> freeBoardList = freeBoardMapper.selectAllFreeList(map);
		
		// 뷰로 보낼 데이터
		model.addAttribute("freeBoardList", freeBoardList);
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "/free/list?recordPerPage=" + recordPerPage));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		model.addAttribute("recordPerPage", recordPerPage);
		
	}

	@Override
	public int addFree(HttpServletRequest request) {
		
		String id = request.getParameter("id");
		String freeTitle = securityUtil.preventXSS(request.getParameter("freeTitle"));		// securityUtil내용 타이틀에 적용
		String freeContent = securityUtil.preventXSS(request.getParameter("freeContent"));
		String ip = request.getRemoteAddr();

		FreeBoardDTO freeBoard = new FreeBoardDTO();
		freeBoard.setId(id);
		freeBoard.setFreeTitle(freeTitle);
		freeBoard.setFreeContent(freeContent);
		freeBoard.setIp(ip);
		
		return freeBoardMapper.insertFree(freeBoard);
		
	}
	
	
	@Transactional
	@Override
	public int addReply(HttpServletRequest request) {
		
		// 작성자, 제목 
		String id = request.getParameter("id");
		String freeTitle = securityUtil.preventXSS(request.getParameter("freeTitle"));
		String freeContent = securityUtil.preventXSS(request.getParameter("freeContent"));
		
		// IP
		String ip = request.getRemoteAddr();
		
		// 원글의 DEPTH, GROUP_NO, GROUP_ORDER
		int depth = Integer.parseInt(request.getParameter("depth"));
		int groupNo = Integer.parseInt(request.getParameter("groupNo"));
		int groupOrder = Integer.parseInt(request.getParameter("groupOrder"));
		
		// 원글DTO(updatePreviousReply를 위함)
		FreeBoardDTO bbs = new FreeBoardDTO();
		bbs.setDepth(depth);
		bbs.setGroupNo(groupNo);
		bbs.setGroupOrder(groupOrder);
		
		// updatePreviousReply 쿼리 실행
		freeBoardMapper.updatePreviousReply(bbs);
		
		// 답글DTO
		FreeBoardDTO reply = new FreeBoardDTO();
		reply.setId(id);
		reply.setFreeTitle(freeTitle);
		reply.setFreeContent(freeContent);
		reply.setIp(ip);
		reply.setDepth(depth + 1);            
		reply.setGroupNo(groupNo);            
		reply.setGroupOrder(groupOrder + 1);  
		
		return freeBoardMapper.insertReply(reply);
		
	}

	@Override
	public int removeFree(int freeBoardNo) {
		return freeBoardMapper.deleteFree(freeBoardNo);
	}
	
	
	@Override
	public FreeBoardDTO getFreeBoardByNo(int freeBoardNo) {
		return freeBoardMapper.selectBoardByNo(freeBoardNo);
	}
	
	@Override
	public void findFreeList(HttpServletRequest request, Model model) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("freeBoardNo"));
		int freeBoardNo = Integer.parseInt(opt.orElse("0"));
		
		FreeBoardDTO freeBoard = freeBoardMapper.selectBoardByNo(freeBoardNo);
		model.addAttribute("FreeBoard", freeBoard);
	}
	
	@Override
	public int modifyFree(HttpServletRequest request) {
		String id = request.getParameter("id");
		String freeContent = securityUtil.preventXSS(request.getParameter("freeContent"));
		String ip = request.getRemoteAddr();
		int freeBoardNo = Integer.parseInt(request.getParameter("freeBoardNo"));
		

		FreeBoardDTO freeBoard = new FreeBoardDTO();
		freeBoard.setId(id);
		freeBoard.setFreeContent(freeContent);
		freeBoard.setIp(ip);
		freeBoard.setFreeBoardNo(freeBoardNo);
		
		System.out.println(freeBoard);
		
		int result = freeBoardMapper.modifyFree(freeBoard);
		
		if(result > 0) {
			System.out.println("수정 성공");
		} else {
			System.out.println("실패");
		}
		
		return result;
	}

}
