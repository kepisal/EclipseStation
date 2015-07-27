package Model;

import java.io.Serializable;

public class Article implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String author;
	private String title;
	private String publishDate;
	private String content;
	public static int MAX_ID = 1;

	public Article(String author, String title, String content, String publishDate){
		this.id = MAX_ID++;
		this.author = author;
		this.title = title;
		this.content = content;
		this.publishDate = publishDate;		 
	}

	public void setData(String author, String title, String content) {
		this.author = author;
		this.title = title;
		this.content = content;

	}
	
	public int getId() {
		return id;
	}

	public Article clone(int id) {
		this.id = id;
		MAX_ID--;
		return this;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPublishDate() {
		return publishDate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String toString() {
		return String
				.format("ID:%d, Author:%s, Title:%s, Publish Date:%s, Content:%s",
						id, author, title, publishDate, content);
	}

}
