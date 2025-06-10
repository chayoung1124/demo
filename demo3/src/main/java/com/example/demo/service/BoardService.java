package com.example.demo.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.BoardDao;
import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.BoardVo;
import com.example.demo.model.MemVo;

@Service
@Transactional
public class BoardService {
	@Autowired
	private BoardDao dao;
	@Autowired
	private BoardMapper m;
	
	public void insertBoard(BoardVo vo) {
		System.out.println("실행된거임" + vo);
		m.insertBoard(vo);
	}

	public List<BoardVo> selectBoards() {
		System.out.println("service => " + m.selectBoards());
		return m.selectBoards();
	}

	public void updateBoard(BoardVo vo) {
		m.updateBoard(vo);
	}

	public void deleteBoard(int boardNo) {
		m.deleteBoard(boardNo);
	}

	public void savePost(BoardVo vo) {
		m.insertBoard(vo);
	}

	public BoardVo selectView(int boardNo) {
		return m.selectView(boardNo);
	}

	public void updateMasking(BoardVo vo) {
		m.updateMasking(vo);
	}

	public MemVo selectMemId(String memberId) {
		return m.selectMemId(memberId);
	}

	public MemVo getMemId(String memberId) {
		return m.getMemId(memberId);
	}

	public int getNoticeCount() {
		return m.getNoticeCount();
	}

	public boolean checkPassword(int boardNo, String inputPassword) {
		String savedPassword = m.selectPassword(boardNo);
		return inputPassword.equals(savedPassword);
	}

	public void insertImage(BoardVo vo) {
		m.insertImage(vo);
		
	}
}
