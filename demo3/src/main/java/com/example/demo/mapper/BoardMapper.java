package com.example.demo.mapper;

import com.example.demo.model.BoardVo;
import com.example.demo.model.MemVo;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface BoardMapper {
	List<BoardVo> selectBoards();

	void insertBoard(BoardVo vo);

	void updateBoard(BoardVo vo);

	void deleteBoard(int boardNo);

	BoardVo selectView(int boardNo);

	void updateMasking(BoardVo vo);

	MemVo selectMemId(String memberId);

	MemVo getMemId(String memberId);

	int getNoticeCount();

	String selectPassword(int boardNo);

	void insertImage(BoardVo vo);
}
