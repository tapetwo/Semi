package com.gdu.semi.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semi.domain.AttachDTO;
import com.gdu.semi.domain.UploadBoardDTO;

@Mapper
public interface UploadBoardMapper {
	public int selectUploadListCount();
	public List<UploadBoardDTO> selectUploadListByMap( Map<String, Object> map );
	public int updateHit(int uploadBoardNo);
	
	public int selectFindUploadCount(Map<String, Object> map);
	public List<UploadBoardDTO> selectFindUploadList(Map<String, Object> map);
	
	public int insertUpload(UploadBoardDTO upload);
	public int insertAttach(AttachDTO attach);
	
	public int updateIncreasePoint(String id);
	public int updateDownloadPoint(String id);
	
	public UploadBoardDTO selectUploadByNo(int uploadBoardNo);
	public List<AttachDTO> selectAttachList(int uploadBoardNo);
	
	public int selectPoint(String id);
	public int updateDownloadCnt(int attachNo);
	public AttachDTO selectAttachByNo(int uploadBoardNo);
	public int updateUpload(UploadBoardDTO upload);
	
	public int deleteAttach(int attachNo);
	public int deleteUpload(int uploadBoardNo);
	public List<AttachDTO> selectAttachListInYesterday();
	
}
