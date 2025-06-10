package com.example.demo.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;

public final class RequestWrapper extends HttpServletRequestWrapper {
	private boolean xssDetected = false;

	public RequestWrapper(HttpServletRequest servletRequest) {
		super(servletRequest);
	}

	public String[] getParameterValues(String parameter) {
		String[] values = super.getParameterValues(parameter);
		if (values == null) {
			return null;
		}
		int count = values.length;
		String[] encodedValues = new String[count];
		
		for (int i = 0; i < count; i++) {
			encodedValues[i] = cleanXSS(values[i]);
		}
		
		return encodedValues;
	}

	@Override
	public String getParameter(String parameter) {
		String value = super.getParameter(parameter);
		if (value == null) {
			return null;
		}
		
		return cleanXSS(value);
	}

	@Override
	public String getHeader(String name) {
		String value = super.getHeader(name);
		if (value == null) {
			return null;
		}
		
		return cleanXSS(value);
	}

	private String cleanXSS(String value) {
		if (value == null) {
			return value;
		}

		if (value.toLowerCase().contains("<script") || value.toLowerCase().contains("javascript:")) {
			xssDetected = true;
		}

		System.out.println("XSS Filter Before : " + value);
		value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
		value = value.replaceAll("\\(", "&lpar;").replaceAll("\\)", "&rpar;");
		value = value.replaceAll("'", "&apos;").replaceAll("\"", "&quot;");
		value = value.replaceAll("eval\\((.*)\\)", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		value = value.replaceAll("script", "");
		System.out.println("XSS Filter After : " + value);

		return value;
	}

	public boolean isXssDetected() {
		boolean detected = xssDetected;
		xssDetected = false;
		return detected;
	}
}