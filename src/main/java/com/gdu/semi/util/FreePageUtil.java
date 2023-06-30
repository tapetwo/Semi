package com.gdu.semi.util;

import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class FreePageUtil {

	private int page;                
	private int totalRecord;         
	private int recordPerPage;       
	private int begin;               
	private int end;                
	
	private int totalPage;           
	private int pagePerBlock = 5;    
	private int beginPage;         
	private int endPage;            
	
	public void setPageUtil(int page, int recordPerPage, int totalRecord) {
		
		this.page = page;
		this.recordPerPage = recordPerPage;
		this.totalRecord = totalRecord;
		
		begin = (page - 1) * recordPerPage + 1;
		end = begin + recordPerPage - 1;
		if(end > totalRecord) {
			end = totalRecord;
		}
		
		totalPage = totalRecord / recordPerPage;
		if(totalRecord % recordPerPage != 0) {
			totalPage++;
		}
		
		beginPage = ((page - 1) / pagePerBlock) * pagePerBlock + 1;
		endPage = beginPage + pagePerBlock - 1;
		if(endPage > totalPage) {
			endPage = totalPage;
		}
		
	}
	
	public String getPaging(String path) {
		
		StringBuilder sb = new StringBuilder();
		
		if(path.contains("?")) {
			path += "&";
		} else {
			path += "?";
		}
		
		if(beginPage != 1) {
			sb.append("<a href=\"" + path + "page=" + (beginPage - 1) + "\"><i class=\"fa-solid fa-circle-left\"></i></a>");
		}
		
		for(int p = beginPage; p <= endPage; p++) {
			if(p == page) {
				sb.append(p);
			} else {
				sb.append("<a href=\"" + path + "page=" + p + "\">" + p + "</a>");
			}
		}
		
		if(endPage != totalPage) {
			sb.append("<a href=\"" + path + "page=" + (endPage + 1) + "\"><i class=\"fa-solid fa-circle-right\"></i></a>");
		}
		
		return sb.toString();
		
	}
	
}
