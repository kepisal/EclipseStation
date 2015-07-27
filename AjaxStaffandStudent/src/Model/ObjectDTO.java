package Model;


public class ObjectDTO {
	private String stuid;
	private String stuname;
	private int gender;
	private String unversity;
	private String classes;
	private int status;
	/**
	 * @return the stuid
	 */
	public String getStuid() {
		return stuid;
	}
	public ObjectDTO(){}
	public ObjectDTO(String stuid, String stuname, int gender,
			String unversity, String classes, int status) {
		super();
		this.stuid = stuid;
		this.stuname = stuname;
		this.gender = gender;
		this.unversity = unversity;
		this.classes = classes;
		this.status = status;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "ObjectDTO [stuid=" + stuid + ", stuname=" + stuname
				+ ", gender=" + gender + ", unversity=" + unversity
				+ ", classes=" + classes + ", status=" + status + "]";
	}
	/**
	 * @param stuid the stuid to set
	 */
	public void setStuid(String stuid) {
		this.stuid = stuid;
	}
	/**
	 * @return the stuname
	 */
	public String getStuname() {
		return stuname;
	}
	/**
	 * @param stuname the stuname to set
	 */
	public void setStuname(String stuname) {
		this.stuname = stuname;
	}
	/**
	 * @return the gender
	 */
	public int getGender() {
		return gender;
	}
	/**
	 * @param gender the gender to set
	 */
	public void setGender(int gender) {
		this.gender = gender;
	}
	/**
	 * @return the unversity
	 */
	public String getUnversity() {
		return unversity;
	}
	/**
	 * @param unversity the unversity to set
	 */
	public void setUnversity(String unversity) {
		this.unversity = unversity;
	}
	/**
	 * @return the classes
	 */
	public String getClasses() {
		return classes;
	}
	/**
	 * @param classes the classes to set
	 */
	public void setClasses(String classes) {
		this.classes = classes;
	}
	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}
}




