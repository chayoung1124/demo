package com.example.demo.model;

import java.sql.Date;

import com.example.demo.model.BoardVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardVo {

	private int board_no; // 게시글 번호
	private String board_title; // 게시글 제목
	private String board_writer; // 게시글 작성자
	private Date board_date; // 게시글 등록일
	private String board_content; // 게시글 내용
	private Date udp_date; // 게시글 수정일
	private String member_name; // 회원 이름
	private String file_name; // 게시글 첨부파일
	private int open_yn; // 게시글 공개여부 (1:공개 / 0:비공개)
	private int notice_no; // 공지사항 (1:공지 / 0:일반)
	private String board_pw; // 게시글 비밀번호 (숫자 4자리, 비공개 게시글 시)
	private String file_path; // 파일 저장 경로
	private String image_name; //이미지명
	private String image_path; //이미지 저장 경로
}
