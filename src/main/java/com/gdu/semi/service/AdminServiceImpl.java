package com.gdu.semi.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gdu.semi.domain.AllUserDTO;
import com.gdu.semi.domain.BoardDTO;
import com.gdu.semi.mapper.AdminMapper;
import com.gdu.semi.util.PageUtil;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	private AdminMapper adminMapper;
	
	@Autowired
	private PageUtil pageUtil;
	
	@Override
	public Map<String, Object> findAllUsers(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Map<String, Object> map = new HashMap<>();
		int totalRecord = adminMapper.selectAllUserCountByQuery(map);
		int sleepUserCnt = adminMapper.selectSleepUserCountByQuery(map);
		int userCnt = adminMapper.selectUserCountByQuery(map);
		
		pageUtil.setPageUtil(page, totalRecord);

		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		List<AllUserDTO> users = adminMapper.selectAllUserList(map);
		
		Map<String, Object> result = new HashMap<>();
		if(users.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("sleepUserCnt", sleepUserCnt);
			result.put("status", 500);
		} else {
			result.put("users", users);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("sleepUserCnt", sleepUserCnt);
			result.put("userCnt", userCnt);
			result.put("paging", pageUtil.getPaging(request.getContextPath() + "/admin/list/user"));
			result.put("status", 200);
		}
		return result;
	}
	
	@Override
	public Map<String, Object> findUsers(HttpServletRequest request) {
		
		String state = request.getParameter("state");
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String start = request.getParameter("start");
		String stop = request.getParameter("stop");
		String first = request.getParameter("first");
		String last = request.getParameter("last");
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("start", start);
		map.put("stop", stop);
		map.put("first", first);
		map.put("last", last);
		
		int sleepUserCnt = 0;
		int totalRecord = 0;
		List<AllUserDTO> users = null;
		
		if(state.equals("active")) {
			totalRecord = adminMapper.selectUserCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			users = adminMapper.selectUsersByQuery(map);
			
		} else if(state.equals("sleep")){
			
			totalRecord = adminMapper.selectSleepUserCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			users = adminMapper.selectSleepUsersByQuery(map);
		} else {
			sleepUserCnt = adminMapper.selectSleepUserCountByQuery(map);
			totalRecord = adminMapper.selectUserCountByQuery(map) + sleepUserCnt;
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			users = adminMapper.selectAllUserList(map);
		}
		
		String path = null;
		
		switch(column) {
		case "ID":
			path = request.getContextPath() + "/list/searchUsers?column=" + column + "&query=" + query;
			break;
		case "CREATE_DATE":
		case "SLEEP_DATE":
		case "POINT":
			path = request.getContextPath() + "/list/searchUsers?column=" + column + "&start=" + start + "&stop=" + stop;
			break;
		default : path = request.getContextPath() + "/admin/list/searchUsers";
		}
		
		Map<String, Object> result = new HashMap<>();
		if(users.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("status", 500);
		} else {
			result.put("users", users);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("sleepUserCnt", sleepUserCnt);
			result.put("paging", pageUtil.getPaging(path));
			result.put("status", 200);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public Map<String, Object> retireUser(HttpServletRequest request) {
		
		String id = request.getParameter("id");
		String userType = request.getParameter("userType");
		
		Map<String, Object> map = new HashMap<>();
		map.put("userType", userType);
		map.put("id", id);
		
		int insertResult = adminMapper.insertRetireUser(map);
		int deleteResult = 0;
		
		if(userType.equals("USERS")) {
			deleteResult = adminMapper.deleteUser(id);
		} else {
			deleteResult = adminMapper.deleteSleepUser(id);
		}
		
		Map<String, Object> result = new HashMap<>();
		
		if(deleteResult > 0 && insertResult > 0) {
			result.put("message", id + " 회원이 삭제되었습니다.");
			result.put("status", 200);
		} else {
			result.put("message", "회원 삭제가 실패하였습니다.");
			result.put("status", 500);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public Map<String, Object> restoreUser(HttpServletRequest request) {
		String id = request.getParameter("id");
		
		int insertResult = adminMapper.insertRestoreUser(id);
		insertResult += adminMapper.insertAccessUser(id);
		int deleteResult = 0;
		
		Map<String, Object> result = new HashMap<>();
		if(insertResult > 0) {
			deleteResult = adminMapper.deleteSleepUser(id);
		}
		
		if(deleteResult > 0 && insertResult > 0) {
			result.put("message", id + " 회원이 정상회원으로 변경되었습니다.");
			result.put("status", 200);
		} else {
			result.put("message", "정상회원 변경이 실패하였습니다.");
			result.put("status", 500);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public Map<String, Object> dormantUser(HttpServletRequest request) {
		String id = request.getParameter("id");
		
		int insertResult = adminMapper.insertdormantUser(id);
		int deleteResult = 0;
		
		Map<String, Object> result = new HashMap<>();
		if(insertResult > 0) {
			deleteResult = adminMapper.deleteUser(id);
		}
		
		if(deleteResult > 0 && insertResult > 0) {
			result.put("message", id + " 회원이 휴면회원으로 변경되었습니다.");
			result.put("status", 200);
		} else {
			result.put("message", "휴면회원 변경이 실패하였습니다.");
			result.put("status", 500);
		}
		
		return result;
	}
	
	@Override
	public Map<String, Object> findAllBoards(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Map<String, Object> map = new HashMap<>();
		int totalRecord = adminMapper.selectAllBoardCountByQuery(map);
		
		pageUtil.setPageUtil(page, totalRecord);

		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		List<BoardDTO> boards = adminMapper.selectAllBoardByQuery(map);
		
		Map<String, Object> result = new HashMap<>();
		if(boards.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("status", 500);
		} else {
			result.put("boards", boards);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("paging", pageUtil.getPaging(request.getContextPath() + "/admin/list/board"));
			result.put("status", 200);
		}
		return result;
	}
	
	@Override
	public Map<String, Object> findBoards(HttpServletRequest request) {
		
		String board = request.getParameter("board");
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String start = request.getParameter("start");
		String stop = request.getParameter("stop");
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("start", start);
		map.put("stop", stop);
		map.put("board", board);

		int totalRecord = 0;
		List<BoardDTO> boards = null;
		
		if(board.equals("FREE_BOARD")) {
			totalRecord = adminMapper.selectFreeCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			boards = adminMapper.selectFreeBoardByQuery(map);
			
		} else if(board.equals("GALLERY_BOARD") || board.equals("UPLOAD_BOARD")){
			
			totalRecord = adminMapper.selectGalleryUploadCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			if(board.equals("GALLERY_BOARD")) {
				boards = adminMapper.selectGalleryBoardByQuery(map);
			} else {
				boards = adminMapper.selectUploadBoardByQuery(map);
			}
		} else {
			totalRecord = adminMapper.selectAllBoardCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			boards = adminMapper.selectAllBoardByQuery(map);
		}
		
		String path = null;
		
		switch(column) {
		case "ID":
		case "TITLE":
		case "CONTENT":
		case "TITLE_CONTENT":
			path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&query=" + query + "&board=" + board;
			break;
		case "CREATE_DATE":
			path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&start=" + start + "&stop=" + stop + "&board=" + board;
			break;
		default : path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&board=" + board;
		}
		
		Map<String, Object> result = new HashMap<>();
		if(boards.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("status", 500);
		} else {
			result.put("boards", boards);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("paging", pageUtil.getPaging(path));
			result.put("status", 200);
		}
		
		return result;
	}
	
	@Override
	public Map<String, Object> deleteBoard(List<String> id, List<String> boardNo, List<String> boards) {

		Map<String, Object> map = new HashMap<>();
		int deleteResult = 0;
		
		int i = 0;
		for (String board : boards) {
			
			map.put("id", id.get(i));
			map.put("boardNo", boardNo.get(i));
			
			if(board.equals("FREE_BOARD")) {
				deleteResult += adminMapper.deleteFreeBoard(map);
			} else if(board.equals("GALLERY_BOARD")){
				deleteResult += adminMapper.deleteGalleryBoard(map);
			} else if(board.equals("UPLOAD_BOARD")) {
				deleteResult += adminMapper.deleteUploadBoard(map);
			}
			map.clear();
			i++;
        }
		
		Map<String, Object> result = new HashMap<>();
		
		if(deleteResult == boards.size()) {
			result.put("message", "게시물이 삭제되었습니다.");
			result.put("status", 200);
		} else {
			result.put("message", "게시물 삭제가 실패하였습니다.");
			result.put("status", 500);
		}
		
		return result;
	}
	
	@Override
	public Map<String, Object> findAllBoardsFromId(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		
		Map<String, Object> map = new HashMap<>();
		map.put("id", id);
		map.put("type", type);
		
		int totalRecord = adminMapper.selectAllBoardCountByQuery(map);
		
		pageUtil.setPageUtil(page, totalRecord);
		
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		List<BoardDTO> boards = adminMapper.selectAllBoardByQuery(map);
		
		Map<String, Object> result = new HashMap<>();
		if(boards.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("status", 500);
		} else {
			result.put("boards", boards);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("paging", pageUtil.getPaging(request.getContextPath() + "/admin/user/detail"));
			result.put("status", 200);
		}
		return result;
	}
	
	@Override
	public Map<String, Object> findBoardsFromId(HttpServletRequest request) {
		
		String board = request.getParameter("board");
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		String start = request.getParameter("start");
		String stop = request.getParameter("stop");
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		Map<String, Object> map = new HashMap<>();
		map.put("column", column);
		map.put("query", query);
		map.put("start", start);
		map.put("stop", stop);
		map.put("board", board);
		map.put("id", id);
		map.put("type", type);

		int totalRecord = 0;
		List<BoardDTO> boards = null;
		
		if(board.equals("FREE_BOARD")) {
			totalRecord = adminMapper.selectFreeCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			boards = adminMapper.selectFreeBoardByQuery(map);
			
		} else if(board.equals("GALLERY_BOARD") || board.equals("UPLOAD_BOARD")){
			
			totalRecord = adminMapper.selectGalleryUploadCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			if(board.equals("GALLERY_BOARD")) {
				boards = adminMapper.selectGalleryBoardByQuery(map);
			} else {
				boards = adminMapper.selectUploadBoardByQuery(map);
			}
		} else {
			totalRecord = adminMapper.selectAllBoardCountByQuery(map);
			pageUtil.setPageUtil(page, totalRecord);
			
			map.put("begin", pageUtil.getBegin());
			map.put("end", pageUtil.getEnd());
			boards = adminMapper.selectAllBoardByQuery(map);
		}
		
		String path = null;
		
		switch(column) {
		case "TITLE":
		case "CONTENT":
		case "TITLE_CONTENT":
			path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&query=" + query + "&board=" + board;
			break;
		case "CREATE_DATE":
			path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&start=" + start + "&stop=" + stop + "&board=" + board;
			break;
		default : path = request.getContextPath() + "/admin/list/searchBoards?column=" + column + "&board=" + board;
		}
		
		Map<String, Object> result = new HashMap<>();
		if(boards.size() == 0) {
			result.put("message", "조회된 결과가 없습니다.");
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("status", 500);
		} else {
			result.put("boards", boards);
			result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
			result.put("totalRecord", totalRecord);
			result.put("paging", pageUtil.getPaging(path));
			result.put("status", 200);
		}
		
		return result;
	}
}
