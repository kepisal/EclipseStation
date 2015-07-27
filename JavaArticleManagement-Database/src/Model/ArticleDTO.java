package Model;
public class ArticleDTO {
	private int id;
	private String author;
	private String title;
	private String publishDate;
	private String content;
	public ArticleDTO(){}
	public ArticleDTO(int id, String author, String title, String content, String publishDate){
		this.id = id;
		this.author = author;
		this.title = title;
		this.content = content;
		this.publishDate = publishDate;		 
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public void setPublishDate(String publishDate) {
		this.publishDate = publishDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String toString() {
		return String
				.format("ID:%d, Author:%s, Title:%s, Publish Date:%s\n Content:%s",
						id, author, title, publishDate, content);
	}
}