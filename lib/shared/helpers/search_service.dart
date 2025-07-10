import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// A scalable search service that uses existing localizations for multilingual search.
/// 
/// This service provides language-agnostic search functionality by leveraging
/// the app's existing localization system, making it easy to add new languages
/// without modifying search logic.
class SearchService {
  /// Normalizes text for better search matching by removing accents and special characters.
  /// This makes the search more flexible and language-agnostic.
  /// 
  /// Parameters:
  /// - [text]: The text to normalize
  /// 
  /// Returns normalized text without accents and special characters.
  static String normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Creates a comprehensive searchable text from multiple fields.
  /// 
  /// This method combines original text with normalized versions for better
  /// multilingual search capabilities.
  /// 
  /// Parameters:
  /// - [fields]: List of text fields to include in search
  /// 
  /// Returns a combined searchable text string.
  static String createSearchableText(List<String> fields) {
    final normalizedFields = fields.map((field) => normalizeText(field)).toList();
    return [...fields, ...normalizedFields].join(' ').toLowerCase();
  }

  /// Performs a fuzzy search on a list of items using a search query.
  /// 
  /// This method supports:
  /// - Multi-term search (all terms must be found)
  /// - Case-insensitive matching
  /// - Accent-insensitive matching
  /// - Language-agnostic search
  /// 
  /// Parameters:
  /// - [items]: List of items to search through
  /// - [searchQuery]: The search query string
  /// - [getSearchableText]: Function to extract searchable text from each item
  /// 
  /// Returns filtered list of items matching the search criteria.
  static List<T> fuzzySearch<T>({
    required List<T> items,
    required String searchQuery,
    required String Function(T item) getSearchableText,
  }) {
    if (searchQuery.isEmpty) return items;
    
    final searchLower = searchQuery.toLowerCase().trim();
    final searchTerms = searchLower.split(' ').where((term) => term.isNotEmpty).toList();
    
    return items.where((item) {
      final searchableText = getSearchableText(item);
      return searchTerms.every((term) => searchableText.contains(term));
    }).toList();
  }

  /// Gets localized search hints for common terms.
  /// 
  /// This method provides search suggestions based on the current locale,
  /// making it easier for users to find content in their preferred language.
  /// 
  /// Parameters:
  /// - [context]: Build context to access localizations
  /// 
  /// Returns a list of search hints in the current language.
  static List<String> getSearchHints(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return [];
    
    return [
      l10n.waterMonitoring,
      l10n.waterQuality,
      l10n.waterLevel,
      l10n.excellent,
      l10n.good,
      l10n.acceptable,
      l10n.bad,
      l10n.nonPotable,
      l10n.withoutWater,
      l10n.received,
      l10n.inProgress,
      l10n.closed,
      l10n.normal,
      l10n.alert,
      l10n.critical,
    ];
  }

  /// Checks if a search query matches any localized terms.
  /// 
  /// This method helps improve search accuracy by checking if the query
  /// matches common localized terms from the app's translation files.
  /// 
  /// Parameters:
  /// - [context]: Build context to access localizations
  /// - [query]: The search query to check
  /// 
  /// Returns true if the query matches any localized terms.
  static bool matchesLocalizedTerms(BuildContext context, String query) {
    final hints = getSearchHints(context);
    final normalizedQuery = normalizeText(query);
    
    return hints.any((hint) => 
      normalizeText(hint).contains(normalizedQuery) ||
      normalizedQuery.contains(normalizeText(hint))
    );
  }
} 