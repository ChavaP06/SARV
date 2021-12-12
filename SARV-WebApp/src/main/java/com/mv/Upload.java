package com.mv;

import java.awt.ItemSelectable;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileExistsException;
import org.apache.commons.io.FilenameUtils;

@SuppressWarnings("serial")

public class Upload extends HttpServlet {
	// private String uploadPath = "c://temp"; // directory of uploaded files
	private String absolutePath = "";

	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {

			// Create a factory for disk-based file items
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// Create a new file upload handler
			ServletFileUpload upload = new ServletFileUpload(factory);

			List<FileItem> items = upload.parseRequest(request); // Get all the files
			Iterator<FileItem> i = items.iterator();
			String fileSizeExceededChecker = "";
			String invalidFileInput = "";
			while (i.hasNext()) {
				FileItem fi = (FileItem) i.next();

				if (!fi.isFormField()) {
					String fileName = fi.getName();
					// check if file size exceeded 10KB if so teleport to index.jsp with error checker.
					if (fi.getSize() > 1024 * 10) {
						fileSizeExceededChecker = "FILE_SIZE_EXCEEDED";
						request.setAttribute("errorCheck=True", fileSizeExceededChecker);
						request.getRequestDispatcher("/index.jsp").forward(request, response);
						return;
					}
					// System.out.print(fi.getSize());
					// get file extension
					String ext1 = FilenameUtils.getExtension(fileName);
					if (fileName != null && ext1.equals("csv")) {

						File fullFile = new File(fi.getName());

						// File savedFile = new File(uploadPath, fullFile.getName());
						// File savedFile = new File(uploadPath, "data" + "." + ext1);

						File tempFile = File.createTempFile("data-", "." + ext1);
						// File tempFile = File.createTempFile("MyAppName-", ".tmp");
						absolutePath = tempFile.getAbsolutePath();
						try {
							// fi.write(savedFile);

							fi.write(tempFile);
							tempFile.deleteOnExit();

						} catch (FileExistsException e) {
							System.out.print("Error");

						}
					} 
					//check if file isn't csv.
					else if(fileName != null && !(ext1.equals("csv"))){
						invalidFileInput = "FILE_TYPE_INVALID";
						request.setAttribute("errorCheck=True", invalidFileInput);
						request.getRequestDispatcher("/index.jsp").forward(request, response);
						return;
					}

				} else {
					String fieldname = fi.getFieldName();
					String fieldvalue = fi.getString();

					System.out.println(fieldname + " >> " + fieldvalue);

					/*
					 * if(fieldname.equals("support-slider1")) {
					 * request.setAttribute("support-slider1", fieldvalue); }
					 * if(fieldname.equals("support-slider2")) {
					 * request.setAttribute("support-slider2", fieldvalue); }
					 * if(fieldname.equals("conf-slider")) {
					 * request.setAttribute("confidence-slider", fieldvalue); }
					 * if(fieldname.equals("rules-slider")) { request.setAttribute("rules-slider",
					 * fieldvalue); } if(fieldname.equals("graph")) {
					 * request.setAttribute("graph-image", fieldvalue); }
					 */

					switch (fieldname) {
					case "support-slider1":
						request.setAttribute("support-slider1", fieldvalue);
						break;
					case "support-slider2":
						request.setAttribute("support-slider2", fieldvalue);
						break;
					case "conf-slider":
						request.setAttribute("confidence-slider", fieldvalue);
						break;
					case "rules-slider":
						request.setAttribute("rules-slider", fieldvalue);
						break;
					case "graph":
						request.setAttribute("graph-type", fieldvalue);
						break;
					}
				}
			}

			response.setContentType("text/html;charset=GBK");
			// response.getWriter().print("<mce:script language='javascript'><!-- Alert
			// ('successful upload'); window. location. href ='index. jsp'; //
			// --></mce:script>");
			// response.sendRedirect("/index.jsp");
			// response.sendRedirect(request.getContextPath() + "/index.jsp");
			// String variable = request.getParameter("someField");
			// System.out.println("TEST TEST TEST " + variable);

			request.setAttribute("myname", absolutePath);
			request.getRequestDispatcher("/index.jsp").forward(request, response);
		} catch (Exception e) {
			// You can jump to the wrong page
			e.printStackTrace();
		}
	}
	/*
	 * public void init() throws ServletException { File uploadFile = new
	 * File(uploadPath); if (!uploadFile.exists()) { uploadFile.mkdirs(); } }
	 */
}