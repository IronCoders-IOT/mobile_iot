class StatusFormatter {
  static String formatWaterRequestStatus(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return 'Received';
      case 'in_progress':
        return 'In Progress';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  static String formatReportStatus(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return 'Received';
      case 'in_progress':
        return 'In Progress';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }
} 