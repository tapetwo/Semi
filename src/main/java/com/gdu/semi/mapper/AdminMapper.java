package com.gdu.semi.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semi.domain.AllUserDTO;
import com.gdu.semi.domain.BoardDTO;

@Mapper
public interface AdminMapper {
	public List<AllUserDTO> selectAllUserList(Map<String, Object> map);
	public int selectAllUserCountByQuery(Map<String, Object> map);
	public List<AllUserDTO> selectUsersByQuery(Map<String, Object> map);
	public int selectUserCountByQuery(Map<String, Object> map);
	public List<AllUserDTO> selectSleepUsersByQuery(Map<String, Object> map);
	public int selectSleepUserCountByQuery(Map<String, Object> map);
	public int deleteUser(String id);
	public int insertRetireUser(Map<String, Object> map);
	public int deleteSleepUser(String id);
	public int insertRestoreUser(String id);
	public int insertdormantUser(String id);
	public int insertAccessUser(String id);
	public List<BoardDTO> selectAllBoardByQuery(Map<String, Object> map);
	public int selectAllBoardCountByQuery(Map<String, Object> map);
	public int selectGalleryUploadCountByQuery(Map<String, Object> map);
	public int selectFreeCountByQuery(Map<String, Object> map);
	public List<BoardDTO> selectFreeBoardByQuery(Map<String, Object> map);
	public List<BoardDTO> selectGalleryBoardByQuery(Map<String, Object> map);
	public List<BoardDTO> selectUploadBoardByQuery(Map<String, Object> map);
	public int deleteFreeBoard(Map<String, Object> map);
	public int deleteGalleryBoard(Map<String, Object> map);
	public int deleteUploadBoard(Map<String, Object> map);
}
