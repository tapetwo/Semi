package com.gdu.semi.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AdminService {
	public Map<String, Object> findAllUsers(HttpServletRequest request);
	public Map<String, Object> findUsers(HttpServletRequest request);
	public Map<String, Object> retireUser(HttpServletRequest request);
	public Map<String, Object> restoreUser(HttpServletRequest request);
	public Map<String, Object> dormantUser(HttpServletRequest request);
	public Map<String, Object> findAllBoards(HttpServletRequest request);
	public Map<String, Object> findBoards(HttpServletRequest request);
	public Map<String, Object> deleteBoard(List<String> id, List<String> boardNo, List<String> board);
	public Map<String, Object> findAllBoardsFromId(HttpServletRequest request);
	public Map<String, Object> findBoardsFromId(HttpServletRequest request);
}
