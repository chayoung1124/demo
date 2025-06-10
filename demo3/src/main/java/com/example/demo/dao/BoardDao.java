package com.example.demo.dao;

import java.util.*;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.demo.model.BoardVo;
import com.example.demo.model.MemVo;

@Repository
public class BoardDao {

	@Autowired
	private SqlSession sqlsession;

	public void insertBoard(BoardVo vo) {
		sqlsession.insert("BoardMapper.insertBoard", vo);
	}

	public List<BoardVo> selectBoards() {
		return sqlsession.selectList("BoardMapper.selectBoards");
	}

	public void updateBoard(BoardVo vo) {
		sqlsession.update("BoardMapper.updateBoard", vo);
	}

	public void deleteBoard(int board_no) {
		sqlsession.delete("BoardMapper.deleteBoard", board_no);
	}

	public BoardVo selectView(int board_no) {
		return sqlsession.selectOne("BoardMapper.selectView", board_no);
	}

	public MemVo selectMemId(String member_id) {
		return sqlsession.selectOne("BoardMapper.selectMemId", member_id);
	}

	public MemVo getMemId(String member_id) {
		return sqlsession.selectOne("BoardMapper.getMemId", member_id);
	}
	
	public void insertImage(BoardVo vo) {
		sqlsession.insert("BoardMapper.insertImage", vo);
	}
}
