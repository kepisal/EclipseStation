package Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import Model.ArticleDAO;
import Model.ArticleDTO;

public class clsSort {
	public void sort(ArrayList<ArticleDTO> articles,String sortBy, boolean isAscending) {
		try {
			switch (sortBy.toLowerCase()) {
			case "i":// sort by id
				Collections.sort(articles, new Comparator<ArticleDTO>() {
					@Override
					public int compare(ArticleDTO art1, ArticleDTO art2) {
						return art1.getId() > art2.getId() ? 1 : -1; /*
																	 * Sort
																	 * Object By
																	 * Ascending
																	 */
					}
				});
				break;

			case "au":// sort by author
				Collections.sort(articles, new Comparator<ArticleDTO>() {
					@Override
					public int compare(ArticleDTO art1, ArticleDTO art2) {
						return art1.getAuthor().compareTo(art2.getAuthor());/*
																			 * Sort
																			 * Object
																			 * By
																			 * Ascending
																			 */
					}
				});
				break;

			case "t":// Sort by title
				Collections.sort(articles, new Comparator<ArticleDTO>() {
					@Override
					public int compare(ArticleDTO art1, ArticleDTO art2) {
						return art1.getTitle().compareTo(art2.getTitle());/*
																		 * Sort
																		 * Object
																		 * By
																		 * Ascending
																		 */
					}
				});
				break;

			case "p":// sort by Publish Date
				Collections.sort(articles, new Comparator<ArticleDTO>() {
					@Override
					public int compare(ArticleDTO art1, ArticleDTO art2) {
						return art1.getPublishDate().compareTo(
								art2.getPublishDate());/*
														 * Sort Object By
														 * Ascending
														 */
					}
				});
				break;
			default:
				Logger.getLogger().writeLogException(new Exception(), "sort"+sortBy, "class sort");
			}// End of switch
			if (!isAscending)
				Collections.reverse(articles); /* Sort Object by Descending */
		} catch (Exception e) {
			Logger.getLogger().writeLogException(e, "sort", "Management");
		}
		// display();
	}// End of sort();
	/**
	 * Function display without parameter and no return type for manipulating
	 * articles and display all of elements
	 */
}
